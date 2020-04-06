library calendarro;

import 'package:calendarro/calendarro_page.dart';
import 'package:calendarro/date_range.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:calendarro/date_utils.dart';
import 'package:calendarro/default_day_tile_builder.dart';
import 'package:flutter/material.dart';

abstract class DayTileBuilder {
  Widget build(BuildContext context, DateTime date, DateTimeCallback onTap);
}

enum DisplayMode { MONTHS, WEEKS }
enum SelectionMode { SINGLE, MULTI, RANGE }

typedef void DateTimeCallback(DateTime datetime);
typedef void CurrentPageCallback(DateTime pageStartDate, DateTime pageEndDate);

class Calendarro extends StatefulWidget {
  DateTime startDate;
  DateTime endDate;
  DisplayMode displayMode;
  SelectionMode selectionMode;
  DayTileBuilder dayTileBuilder;
  Widget weekdayLabelsRow;
  DateTimeCallback onTap;
  CurrentPageCallback onPageSelected;

  DateTime selectedSingleDate;
  List<DateTime> selectedDates;
  List<DateTime> rglselectedDates;
  List<DateTime> pmsselectedDates;
  List<DateTime> ovlselectedDates;
  List<DateTime> pmsfrstselectedDates;
  List<DateTime> ovlfrstselectedDates;

  int startDayOffset;
  CalendarroState state;

  double dayTileHeight = 40.0;
  double dayLabelHeight = 40.0;

  Calendarro({
    Key key,
    this.startDate,
    this.endDate,
    this.displayMode = DisplayMode.WEEKS,
    this.dayTileBuilder,
    this.selectedSingleDate,
    this.selectedDates,
    this.rglselectedDates,
    this.ovlselectedDates,
    this.pmsselectedDates,
    this.pmsfrstselectedDates,
    this.ovlfrstselectedDates,
    this.selectionMode = SelectionMode.SINGLE,
    this.onTap,
    this.onPageSelected,
    this.weekdayLabelsRow,
  }) : super(key: key) {
    if (startDate == null) {
      startDate = DateUtils.getFirstDayOfCurrentMonth();
    }
    startDate = DateUtils.toMidnight(startDate);

    if (endDate == null) {
      endDate = DateUtils.getLastDayOfCurrentMonth();
    }
    endDate = DateUtils.toMidnight(endDate);

    if (startDate.isAfter(endDate)) {
      throw new ArgumentError("Calendarro: startDate is after the endDate");
    }
    startDayOffset = startDate.weekday - DateTime.monday;

    if (dayTileBuilder == null) {
      dayTileBuilder = DefaultDayTileBuilder();
    }

    if (weekdayLabelsRow == null) {
      weekdayLabelsRow = CalendarroWeekdayLabelsView();
    }

    if (selectedDates == null) {
      selectedDates = List();
    }

     if (rglselectedDates == null) {
      rglselectedDates = List();
    }

     if (ovlselectedDates == null) {
      ovlselectedDates = List();
    }

     if (pmsselectedDates == null) {
      pmsselectedDates = List();
    }



     if (ovlfrstselectedDates == null) {
      ovlfrstselectedDates = List();
    }

     if (pmsfrstselectedDates == null) {
      pmsfrstselectedDates = List();
    } 
  
  }

  static CalendarroState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<CalendarroState>());

  @override
  CalendarroState createState() {
    state = CalendarroState(
        selectedSingleDate: selectedSingleDate,
        selectedDates: selectedDates,
        rglselectedDates: rglselectedDates,
        ovlselectedDates: ovlselectedDates,
        pmsselectedDates: pmsselectedDates,
       
        ovlfrstselectedDates: ovlfrstselectedDates,
        pmsfrstselectedDates: pmsfrstselectedDates,
        
        
        );
    return state;
  }

  void setSelectedDate(DateTime date) {
    state.setSelectedDate(date);
  }

  void toggleDate(DateTime date) {
    state.toggleDateSelection(date);
  }

  void setCurrentDate(DateTime date) {
    state.setCurrentDate(date);
  }

  int getPositionOfDate(DateTime date) {
    int daysDifference =
        date
            .difference(DateUtils.toMidnight(startDate))
            .inDays;
    int weekendsDifference = ((daysDifference + startDate.weekday) / 7).toInt();
    var position = daysDifference - weekendsDifference * 2;
    return position;
  }

  int getPageForDate(DateTime date) {
    if (displayMode == DisplayMode.WEEKS) {
      int daysDifferenceFromStartDate = date
          .difference(startDate)
          .inDays;
      int page = (daysDifferenceFromStartDate + startDayOffset) ~/ 7;
      return page;
    } else {
      var monthDifference = (date.year * 12 + date.month) -
          (startDate.year * 12 + startDate.month);
      return monthDifference;
    }
  }
}

class CalendarroState extends State<Calendarro> {
  DateTime selectedSingleDate;
  List<DateTime> selectedDates;
  List<DateTime> rglselectedDates;
  List<DateTime> ovlselectedDates;
  List<DateTime> pmsselectedDates;
  List<DateTime> ovlfrstselectedDates;
  List<DateTime> pmsfrstselectedDates;

  int pagesCount;
  PageView pageView;

  CalendarroState({
    this.selectedSingleDate,
    this.selectedDates,
    this.rglselectedDates,
    this.pmsselectedDates,
    this.ovlselectedDates,
    
    this.pmsfrstselectedDates,
    this.ovlfrstselectedDates,
    
  });

  @override
  void initState() {
    super.initState();

    if (selectedSingleDate == null) {
      selectedSingleDate = widget.startDate;
    }
  }

  void setSelectedDate(DateTime date) {
    setState(() {
      switch (widget.selectionMode) {
        case SelectionMode.SINGLE:
          selectedSingleDate = date;
          break;
        case SelectionMode.MULTI:
          _setMultiSelectedDate(date);
          _setMultirglSelectedDate(date);
          _setMultiovlSelectedDate(date);
          _setMultipmsSelectedDate(date);
          _setMultiovlfrstSelectedDate(date);
          _setMultipmsfrstSelectedDate(date);
          break;
        case SelectionMode.RANGE:
          _setRangeSelectedDate(date);
          break;
      }
    });
  }

  void setCurrentDate(DateTime date) {
    setState(() {
      int page = widget.getPageForDate(date);
      pageView.controller.jumpToPage(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.displayMode == DisplayMode.WEEKS) {
      int lastPage = widget.getPageForDate(widget.endDate);
      pagesCount = lastPage + 1;
    } else {
      pagesCount = DateUtils.calculateMonthsDifference(
          widget.startDate,
          widget.endDate) + 1;
    }

    pageView = PageView.builder(
      itemBuilder: (context, position) => _buildCalendarPage(position),
      itemCount: pagesCount,
      controller: PageController(
          initialPage:
          selectedSingleDate != null ? widget.getPageForDate(selectedSingleDate) : 0),
      onPageChanged: (page) {
        if (widget.onPageSelected != null) {
          DateRange pageDateRange = _calculatePageDateRange(page);
          widget.onPageSelected(pageDateRange.startDate, pageDateRange.endDate);
        }
      },
    );

    double widgetHeight;
    if (widget.displayMode == DisplayMode.WEEKS) {
      widgetHeight = widget.dayLabelHeight + widget.dayTileHeight;
    } else {
      var maxWeeksNumber = DateUtils.calculateMaxWeeksNumberMonthly(
          widget.startDate,
          widget.endDate);
      widgetHeight = widget.dayLabelHeight
          + maxWeeksNumber * widget.dayTileHeight;
    }

    return Container(
        height: widgetHeight,
        child: pageView);
  }

  bool isDateSelected(DateTime date) {
    switch (widget.selectionMode) {
      case SelectionMode.SINGLE:
        return DateUtils.isSameDay(selectedSingleDate, date);
        break;
      case SelectionMode.MULTI:
        final matchedSelectedDate = selectedDates.firstWhere((currentDate) =>
            DateUtils.isSameDay(currentDate, date),
            orElse: () => null
        );

        return matchedSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (selectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(selectedDates[0], date);
          default:
            var dateBetweenDatesRange = (date.isAfter(selectedDates[0])
                && date.isBefore(selectedDates[1]));
            return DateUtils.isSameDay(date, selectedDates[0])
              || DateUtils.isSameDay(date, selectedDates[1])
              || dateBetweenDatesRange;
        }
        break;
    }
  }

    bool isRglDateSelected(DateTime date) {
    switch (widget.selectionMode) {
      case SelectionMode.SINGLE:
        return DateUtils.isSameDay(selectedSingleDate, date);
        break;
      case SelectionMode.MULTI:
        final matchedrglSelectedDate = rglselectedDates.firstWhere((currentDate) =>
            DateUtils.isSameDay(currentDate, date),
            orElse: () => null
        );

        return matchedrglSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (rglselectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(rglselectedDates[0], date);
          default:
            var dateBetweenrglDatesRange = (date.isAfter(rglselectedDates[0])
                && date.isBefore(rglselectedDates[1]));
            return DateUtils.isSameDay(date, rglselectedDates[0])
              || DateUtils.isSameDay(date, rglselectedDates[1])
              || dateBetweenrglDatesRange;
        }
        break;
    }
  }


    bool isOvlDateSelected(DateTime date) {
    switch (widget.selectionMode) {
      case SelectionMode.SINGLE:
        return DateUtils.isSameDay(selectedSingleDate, date);
        break;
      case SelectionMode.MULTI:
        final matchedovlSelectedDate = ovlselectedDates.firstWhere((currentDate) =>
            DateUtils.isSameDay(currentDate, date),
            orElse: () => null
        );

        return matchedovlSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (ovlselectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(ovlselectedDates[0], date);
          default:
            var dateBetweenovlDatesRange = (date.isAfter(ovlselectedDates[0])
                && date.isBefore(selectedDates[1]));
            return DateUtils.isSameDay(date, ovlselectedDates[0])
              || DateUtils.isSameDay(date, ovlselectedDates[1])
              || dateBetweenovlDatesRange;
        }
        break;
    }
  }

    bool isPmsDateSelected(DateTime date) {
    switch (widget.selectionMode) {
      case SelectionMode.SINGLE:
        return DateUtils.isSameDay(selectedSingleDate, date);
        break;
      case SelectionMode.MULTI:
        final matchedpmsSelectedDate = pmsselectedDates.firstWhere((currentDate) =>
            DateUtils.isSameDay(currentDate, date),
            orElse: () => null
        );

        return matchedpmsSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (pmsselectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(pmsselectedDates[0], date);
          default:
            var dateBetweenpmsDatesRange = (date.isAfter(pmsselectedDates[0])
                && date.isBefore(pmsselectedDates[1]));
            return DateUtils.isSameDay(date, pmsselectedDates[0])
              || DateUtils.isSameDay(date, pmsselectedDates[1])
              || dateBetweenpmsDatesRange;
        }
        break;
    }
  }




    bool isOvlfrstDateSelected(DateTime date) {
    switch (widget.selectionMode) {
      case SelectionMode.SINGLE:
        return DateUtils.isSameDay(selectedSingleDate, date);
        break;
      case SelectionMode.MULTI:
        final matchedOvlfrstSelectedDate = ovlfrstselectedDates.firstWhere((currentDate) =>
            DateUtils.isSameDay(currentDate, date),
            orElse: () => null
        );

        return matchedOvlfrstSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (ovlfrstselectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(ovlfrstselectedDates[0], date);
          default:
            var dateBetweenovlfrstDatesRange = (date.isAfter(ovlfrstselectedDates[0])
                && date.isBefore(ovlfrstselectedDates[1]));
            return DateUtils.isSameDay(date, ovlfrstselectedDates[0])
              || DateUtils.isSameDay(date, ovlfrstselectedDates[1])
              || dateBetweenovlfrstDatesRange;
        }
        break;
    }
  }

    bool isPmsfrstDateSelected(DateTime date) {
    switch (widget.selectionMode) {
      case SelectionMode.SINGLE:
        return DateUtils.isSameDay(selectedSingleDate, date);
        break;
      case SelectionMode.MULTI:
        final matchedpmsfrstSelectedDate = pmsfrstselectedDates.firstWhere((currentDate) =>
            DateUtils.isSameDay(currentDate, date),
            orElse: () => null
        );

        return matchedpmsfrstSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (pmsfrstselectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(pmsfrstselectedDates[0], date);
          default:
            var dateBetweenpmsfrstDatesRange = (date.isAfter(pmsfrstselectedDates[0])
                && date.isBefore(pmsfrstselectedDates[1]));
            return DateUtils.isSameDay(date, pmsfrstselectedDates[0])
              || DateUtils.isSameDay(date, pmsfrstselectedDates[1])
              || dateBetweenpmsfrstDatesRange;
        }
        break;
    }
  }

  void toggleDateSelection(DateTime date) {
    setState(() {
      for (var i = selectedDates.length - 1; i >= 0; i--) {
        if (DateUtils.isSameDay(selectedDates[i], date)) {
          selectedDates.removeAt(i);
          return;
        }
      }

      selectedDates.add(date);
    });
  }

    void togglerglDateSelection(DateTime date) {
    setState(() {
      for (var i = rglselectedDates.length - 1; i >= 0; i--) {
        if (DateUtils.isSameDay(rglselectedDates[i], date)) {
          rglselectedDates.removeAt(i);
          return;
        }
      }

      rglselectedDates.add(date);
    });
  }

    void toggleovlDateSelection(DateTime date) {
    setState(() {
      for (var i = ovlselectedDates.length - 1; i >= 0; i--) {
        if (DateUtils.isSameDay(ovlselectedDates[i], date)) {
          ovlselectedDates.removeAt(i);
          return;
        }
      }

      ovlselectedDates.add(date);
    });
  }

    void togglepmsDateSelection(DateTime date) {
    setState(() {
      for (var i = pmsselectedDates.length - 1; i >= 0; i--) {
        if (DateUtils.isSameDay(pmsselectedDates[i], date)) {
          pmsselectedDates.removeAt(i);
          return;
        }
      }

      pmsselectedDates.add(date);
    });
  }


  


    void toggleovlfrstDateSelection(DateTime date) {
    setState(() {
      for (var i = ovlfrstselectedDates.length - 1; i >= 0; i--) {
        if (DateUtils.isSameDay(ovlfrstselectedDates[i], date)) {
          ovlfrstselectedDates.removeAt(i);
          return;
        }
      }

      ovlfrstselectedDates.add(date);
    });
  }

    void togglepmsfrstDateSelection(DateTime date) {
    setState(() {
      for (var i = pmsfrstselectedDates.length - 1; i >= 0; i--) {
        if (DateUtils.isSameDay(pmsfrstselectedDates[i], date)) {
          pmsfrstselectedDates.removeAt(i);
          return;
        }
      }

     pmsfrstselectedDates.add(date);
    });
  }

  void update() {
    setState(() {});
  }

  Widget _buildCalendarPage(int position) {
    if (widget.displayMode == DisplayMode.WEEKS) {
      return _buildCalendarPageInWeeksMode(position);
    } else {
      return _buildCalendarPageInMonthsMode(position);
    }
  }

  Widget _buildCalendarPageInWeeksMode(int position) {
    DateRange pageDateRange = _calculatePageDateRange(position);

    return CalendarroPage(
        pageStartDate: pageDateRange.startDate,
        pageEndDate: pageDateRange.endDate,
        weekdayLabelsRow: widget.weekdayLabelsRow);
  }

  Widget _buildCalendarPageInMonthsMode(int position) {
    DateRange pageDateRange = _calculatePageDateRangeInMonthsMode(position);

    return CalendarroPage(
      pageStartDate: pageDateRange.startDate,
      pageEndDate: pageDateRange.endDate,
      weekdayLabelsRow: widget.weekdayLabelsRow,
    );
  }

  DateRange _calculatePageDateRange(int pagePosition) {
    if (widget.displayMode == DisplayMode.WEEKS) {
      return _calculatePageDateRangeInWeeksMode(pagePosition);
    } else {
      return _calculatePageDateRangeInMonthsMode(pagePosition);
    }
  }

  DateRange _calculatePageDateRangeInMonthsMode(int pagePosition) {
    DateTime pageStartDate;
    DateTime pageEndDate;

    if (pagePosition == 0) {
      pageStartDate = widget.startDate;
      if (pagesCount <= 1) {
        pageEndDate = widget.endDate;
      } else {
        var lastDayOfMonth = DateUtils.getLastDayOfMonth(widget.startDate);
        pageEndDate = lastDayOfMonth;
      }
    } else if (pagePosition == pagesCount - 1) {
      pageStartDate = DateUtils.getFirstDayOfMonth(widget.endDate);
      pageEndDate = widget.endDate;
    } else {
      DateTime firstDateOfCurrentMonth = DateUtils.addMonths(
          widget.startDate,
          pagePosition);
      pageStartDate = firstDateOfCurrentMonth;
      pageEndDate = DateUtils.getLastDayOfMonth(firstDateOfCurrentMonth);
    }

    return DateRange(pageStartDate, pageEndDate);
  }

  DateRange _calculatePageDateRangeInWeeksMode(int pagePosition) {
    DateTime pageStartDate;
    DateTime pageEndDate;

    if (pagePosition == 0) {
      pageStartDate = widget.startDate;
      pageEndDate =
          DateUtils.addDaysToDate(widget.startDate, 6 - widget.startDayOffset);
    } else if (pagePosition == pagesCount - 1) {
      pageStartDate = DateUtils.addDaysToDate(
          widget.startDate, 7 * pagePosition - widget.startDayOffset);
      pageEndDate = widget.endDate;
    } else {
      pageStartDate = DateUtils.addDaysToDate(
          widget.startDate, 7 * pagePosition - widget.startDayOffset);
      pageEndDate = DateUtils.addDaysToDate(
          widget.startDate, 7 * pagePosition + 6 - widget.startDayOffset);
    }

    return DateRange(pageStartDate, pageEndDate);
  }

  void _setRangeSelectedDate(DateTime date) {
    switch (selectedDates.length) {
      case 0:
        selectedDates.add(date);
        break;
      case 1:
        var firstDate = selectedDates[0];
        if (firstDate.isBefore(date)) {
          selectedDates.add(date);
        } else {
          selectedDates.clear();
          selectedDates.add(date);
          selectedDates.add(firstDate);
        }
        break;
      default:
        selectedDates.clear();
        selectedDates.add(date);
        break;
    }
  }

   void _setRangerglSelectedDate(DateTime date) {
    switch (rglselectedDates.length) {
      case 0:
        rglselectedDates.add(date);
        break;
      case 1:
        var firstDate = rglselectedDates[0];
        if (firstDate.isBefore(date)) {
         rglselectedDates.add(date);
        } else {
          rglselectedDates.clear();
          rglselectedDates.add(date);
          rglselectedDates.add(firstDate);
        }
        break;
      default:
        rglselectedDates.clear();
        rglselectedDates.add(date);
        break;
    }
  }


   void _setRangeovlSelectedDate(DateTime date) {
    switch (ovlselectedDates.length) {
      case 0:
        ovlselectedDates.add(date);
        break;
      case 1:
        var firstDate = ovlselectedDates[0];
        if (firstDate.isBefore(date)) {
          ovlselectedDates.add(date);
        } else {
          ovlselectedDates.clear();
          ovlselectedDates.add(date);
          ovlselectedDates.add(firstDate);
        }
        break;
      default:
        ovlselectedDates.clear();
        ovlselectedDates.add(date);
        break;
    }
  }


   void _setRangepmsSelectedDate(DateTime date) {
    switch (pmsselectedDates.length) {
      case 0:
        pmsselectedDates.add(date);
        break;
      case 1:
        var firstDate = pmsselectedDates[0];
        if (firstDate.isBefore(date)) {
          pmsselectedDates.add(date);
        } else {
         pmsselectedDates.clear();
         pmsselectedDates.add(date);
          pmsselectedDates.add(firstDate);
        }
        break;
      default:
        pmsselectedDates.clear();
        pmsselectedDates.add(date);
        break;
    }
  }

   void _setRangeovlfrstSelectedDate(DateTime date) {
    switch (ovlfrstselectedDates.length) {
      case 0:
        ovlfrstselectedDates.add(date);
        break;
      case 1:
        var firstDate = ovlfrstselectedDates[0];
        if (firstDate.isBefore(date)) {
          ovlfrstselectedDates.add(date);
        } else {
          ovlfrstselectedDates.clear();
          ovlfrstselectedDates.add(date);
          ovlfrstselectedDates.add(firstDate);
        }
        break;
      default:
        ovlfrstselectedDates.clear();
        ovlfrstselectedDates.add(date);
        break;
    }
  }

   void _setRangepmsfrstSelectedDate(DateTime date) {
    switch (pmsfrstselectedDates.length) {
      case 0:
        pmsfrstselectedDates.add(date);
        break;
      case 1:
        var firstDate = pmsfrstselectedDates[0];
        if (firstDate.isBefore(date)) {
          pmsfrstselectedDates.add(date);
        } else {
          pmsfrstselectedDates.clear();
          pmsfrstselectedDates.add(date);
          pmsfrstselectedDates.add(firstDate);
        }
        break;
      default:
        pmsfrstselectedDates.clear();
        pmsfrstselectedDates.add(date);
        break;
    }
  }

  void _setMultiSelectedDate(DateTime date) {
    final alreadyExistingDate = selectedDates.firstWhere((currentDate) =>
        DateUtils.isSameDay(currentDate, date),
        orElse: () => null
    );

    if (alreadyExistingDate != null) {
      selectedDates.remove(alreadyExistingDate);
    } else {
      selectedDates.add(date);
    }
  }
  

    void _setMultirglSelectedDate(DateTime date) {
    final alreadyExistingDate = rglselectedDates.firstWhere((currentDate) =>
        DateUtils.isSameDay(currentDate, date),
        orElse: () => null
    );

    if (alreadyExistingDate != null) {
      rglselectedDates.remove(alreadyExistingDate);
    } else {
      rglselectedDates.add(date);
    }
  }


    void _setMultiovlSelectedDate(DateTime date) {
    final alreadyExistingDate = ovlselectedDates.firstWhere((currentDate) =>
        DateUtils.isSameDay(currentDate, date),
        orElse: () => null
    );

    if (alreadyExistingDate != null) {
      ovlselectedDates.remove(alreadyExistingDate);
    } else {
      ovlselectedDates.add(date);
    }
  }


    void _setMultipmsSelectedDate(DateTime date) {
    final alreadyExistingDate = pmsselectedDates.firstWhere((currentDate) =>
        DateUtils.isSameDay(currentDate, date),
        orElse: () => null
    );

    if (alreadyExistingDate != null) {
      pmsselectedDates.remove(alreadyExistingDate);
    } else {
      pmsselectedDates.add(date);
    }
  }


    void _setMultiovlfrstSelectedDate(DateTime date) {
    final alreadyExistingDate = ovlfrstselectedDates.firstWhere((currentDate) =>
        DateUtils.isSameDay(currentDate, date),
        orElse: () => null
    );

    if (alreadyExistingDate != null) {
      ovlfrstselectedDates.remove(alreadyExistingDate);
    } else {
      ovlfrstselectedDates.add(date);
    }
  }

    void _setMultipmsfrstSelectedDate(DateTime date) {
    final alreadyExistingDate = pmsfrstselectedDates.firstWhere((currentDate) =>
        DateUtils.isSameDay(currentDate, date),
        orElse: () => null
    );

    if (alreadyExistingDate != null) {
      pmsfrstselectedDates.remove(alreadyExistingDate);
    } else {
      pmsfrstselectedDates.add(date);
    }
  }



}
