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
    this.pmsselectedDates,
    this.ovlselectedDates,
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
    if (pmsselectedDates == null) {
      pmsselectedDates = List();
    }
    if (ovlselectedDates == null) {
      ovlselectedDates = List();
    }
    if (pmsfrstselectedDates == null) {
      pmsfrstselectedDates = List();
    }
    if (ovlfrstselectedDates == null) {
      ovlfrstselectedDates = List();
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
        pmsselectedDates: pmsselectedDates,
        ovlselectedDates: ovlselectedDates,
        pmsfrstselectedDates: pmsfrstselectedDates,
        ovlfrstselectedDates: ovlfrstselectedDates,
      
        
        );
    return state;
  }

  void setSelectedDate(DateTime date) {
    state.setSelectedDate(date);
  }

   void setSelectedReglDate(DateTime date) {
    state.setSelectedReglDate(date);
  }
   void setSelectedOvlDate(DateTime date) {
    state.setSelectedOvlDate(date);
  }
   void setSelectedPmsDate(DateTime date) {
    state.setSelectedPmsDate(date);
  }
   void setSelectedPmsfrstDate(DateTime date) {
    state.setSelectedPmsfrstDate(date);
  }
   void setSelectedOvlfrstDate(DateTime date) {
    state.setSelectedOvlfrstDate(date);
  }

  void toggleDate(DateTime date) {
    state.toggleDateSelection(date);
  }

  void togglerglDate(DateTime date) {
    state.toggleDaterglSelection(date);
  }


  void togglepmsDate(DateTime date) {
    state.toggleDatepmsSelection(date);
  }


  void toggleovlDate(DateTime date) {
    state.toggleDateovlSelection(date);
  }


  void toggleovlfrstDate(DateTime date) {
    state.toggleDateovlfrstSelection(date);
  }


  void togglepmsfrstDate(DateTime date) {
    state.toggleDatepmsfrstSelection(date);
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
  List<DateTime> pmsselectedDates;
  List<DateTime> ovlselectedDates;
  List<DateTime> pmsfrstselectedDates;
  List<DateTime> ovlfrstselectedDates;
 
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
 
          break;
        case SelectionMode.RANGE:
          _setRangeSelectedDate(date);

 
          break;
      }
    });
  }

  void setSelectedReglDate(DateTime date) {
    setState(() {
      switch (widget.selectionMode) {
        case SelectionMode.SINGLE:
          selectedSingleDate = date;
          break;
        case SelectionMode.MULTI:
          _setMultiSelectedDate(date);
 
          break;
        case SelectionMode.RANGE:
          _setRangeSelectedDate(date);

 
          break;
      }
    });
  }

    void setSelectedPmsDate(DateTime date) {
    setState(() {
      switch (widget.selectionMode) {
        case SelectionMode.SINGLE:
          selectedSingleDate = date;
          break;
        case SelectionMode.MULTI:
          _setMultiSelectedDate(date);
 
          break;
        case SelectionMode.RANGE:
          _setRangeSelectedDate(date);

          break;
      }
    });
  }

    void setSelectedOvlDate(DateTime date) {
    setState(() {
      switch (widget.selectionMode) {
        case SelectionMode.SINGLE:
          selectedSingleDate = date;
          break;
        case SelectionMode.MULTI:
          _setMultiSelectedDate(date);
 
          break;
        case SelectionMode.RANGE:
          _setRangeSelectedDate(date);
  
 
          break;
      }
    });
  }
   void setSelectedPmsfrstDate(DateTime date) {
    setState(() {
      switch (widget.selectionMode) {
        case SelectionMode.SINGLE:
          selectedSingleDate = date;
          break;
        case SelectionMode.MULTI:
          _setMultiSelectedDate(date);
 
          break;
        case SelectionMode.RANGE:
          //_setRangeSelectedDate(date);
           _setMultiSelectedDate(date);
           
          break;
      }
    });
  }

    void setSelectedOvlfrstDate(DateTime date) {
    setState(() {
      switch (widget.selectionMode) {
        case SelectionMode.SINGLE:
          selectedSingleDate = date;
          break;
        case SelectionMode.MULTI:
          _setMultiSelectedDate(date);
 
          break;
        case SelectionMode.RANGE:
        //  _setRangeSelectedDate(date);
            _setMultiSelectedDate(date);
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
        final matchedSelectedDate = rglselectedDates.firstWhere((currentDate) =>
            DateUtils.isSameDay(currentDate, date),
            orElse: () => null
        );

        return matchedSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (rglselectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(rglselectedDates[0], date);
          default:
            var dateBetweenDatesRange = (date.isAfter(rglselectedDates[0])
                && date.isBefore(rglselectedDates[1]));
            return DateUtils.isSameDay(date, rglselectedDates[0])
              || DateUtils.isSameDay(date, rglselectedDates[1])
              || dateBetweenDatesRange;
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
        final matchedSelectedDate = pmsselectedDates.firstWhere((currentDate) =>
            DateUtils.isSameDay(currentDate, date),
            orElse: () => null
        );

        return matchedSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (pmsselectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(pmsselectedDates[0], date);
          default:
            var dateBetweenDatesRange = (date.isAfter(pmsselectedDates[0])
                && date.isBefore(pmsselectedDates[1]));
            return DateUtils.isSameDay(date, pmsselectedDates[0])
              || DateUtils.isSameDay(date, pmsselectedDates[1])
              || dateBetweenDatesRange;
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
        final matchedSelectedDate = ovlselectedDates.firstWhere((currentDate) =>
            DateUtils.isSameDay(currentDate, date),
            orElse: () => null
        );

        return matchedSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (ovlselectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(ovlselectedDates[0], date);
          default:
            var dateBetweenDatesRange = (date.isAfter(ovlselectedDates[0])
                && date.isBefore(ovlselectedDates[1]));
            return DateUtils.isSameDay(date, ovlselectedDates[0])
              || DateUtils.isSameDay(date, ovlselectedDates[1])
              || dateBetweenDatesRange;
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
        final matchedSelectedDate = pmsfrstselectedDates.firstWhere((currentDate) =>
            DateUtils.isSameDay(currentDate, date),
            orElse: () => null
        );

        return matchedSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (pmsfrstselectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(pmsfrstselectedDates[0], date);
          default:
            var dateBetweenDatesRange = (date.isAfter(pmsfrstselectedDates[0])
                && date.isBefore(pmsfrstselectedDates[1]));
            return DateUtils.isSameDay(date, pmsfrstselectedDates[0])
              || DateUtils.isSameDay(date, pmsfrstselectedDates[1])
              || dateBetweenDatesRange;
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
        final matchedSelectedDate = ovlfrstselectedDates.firstWhere((currentDate) =>
            DateUtils.isSameDay(currentDate, date),
            orElse: () => null
        );

        return matchedSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (ovlfrstselectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(ovlfrstselectedDates[0], date);
          default:
            var dateBetweenDatesRange = (date.isAfter(ovlfrstselectedDates[0])
                && date.isBefore(ovlfrstselectedDates[1]));
            return DateUtils.isSameDay(date, ovlfrstselectedDates[0])
              || DateUtils.isSameDay(date, ovlfrstselectedDates[1])
              || dateBetweenDatesRange;
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

    void toggleDaterglSelection(DateTime date) {
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

    void toggleDateovlSelection(DateTime date) {
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

    void toggleDatepmsSelection(DateTime date) {
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

    void toggleDatepmsfrstSelection(DateTime date) {
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

    void toggleDateovlfrstSelection(DateTime date) {
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


    void _setRangeReglSelectedDate(DateTime date) {
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

    void _setRangeOvlSelectedDate(DateTime date) {
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


    void _setRangeSelectedPmsDate(DateTime date) {
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

      void _setRangeSelectedPmsfrstDate(DateTime date) {
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

      void _setRangeSelectedOvlfrstDate(DateTime date) {
    switch (ovlfrstselectedDates.length) {
      case 0:
        ovlfrstselectedDates.add(date);
        break;
      case 1:
        var firstDate = selectedDates[0];
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
  


  void _setMultiRglSelectedDate(DateTime date) {
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

    void _setMultiOvlSelectedDate(DateTime date) {
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

    void _setMultiPmsSelectedDate(DateTime date) {
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

    void _setMultiOvlfrstSelectedDate(DateTime date) {
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


    void _setMultiPmsfrstSelectedDate(DateTime date) {
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
