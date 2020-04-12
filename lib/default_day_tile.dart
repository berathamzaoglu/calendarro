import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';

class CalendarroDayItem extends StatelessWidget {
  CalendarroDayItem({this.date, this.calendarroState, this.onTap});

  DateTime date;
  CalendarroState calendarroState;
  DateTimeCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool isWeekend = DateUtils.isWeekend(date);
 


    bool isToday = DateUtils.isToday(date);
    calendarroState = Calendarro.of(context);

    bool daySelected = calendarroState.isDateSelected(date);
    bool dayrglSelected = calendarroState.isRglDateSelected(date);
    bool dayovlSelected = calendarroState.isOvlDateSelected(date);
    bool daypmsSelected = calendarroState.isPmsDateSelected(date);
    bool dayovlfrstSelected = calendarroState.isPmsfrstDateSelected(date);
    bool daypmsfrstSelected = calendarroState.isOvlfrstDateSelected(date);

   var textColor;
    if (dayrglSelected) {textColor = Colors.white;
    /*if(isToday){textColor = Colors.black;}*/} 
    if (dayovlfrstSelected) {textColor = Colors.white;} 
    if (daypmsfrstSelected) {textColor = Colors.white;} 
    if (daypmsSelected) {textColor = Color(0xff8a4bf9);} 
    if (dayovlSelected) {textColor = Color(0xff259cfa);} 
    BoxDecoration boxDecoration;
   
    if (daySelected) {     boxDecoration = BoxDecoration(
       gradient: LinearGradient(
        colors: [
      Color(0xffff825f),
      Color(0xffff4c51) ],
      stops: [0,1]),
        
        
        shape: BoxShape.circle);
    } 

        if (dayrglSelected) {
            var renk;
            if(isToday){renk=0xffff4c51 ;}else{renk=0xffffffff;}
      boxDecoration = BoxDecoration(     
        gradient: LinearGradient(
        colors: [
      Color(0xffff825f),
      Color(0xffff4c51) ],
      stops: [0,1]), 
        border: Border.all(
            color: Color(renk),
            width: 2.0,
          ),
        
        shape: BoxShape.circle);
    }  

        if (dayovlSelected) {
      boxDecoration = BoxDecoration(
    		gradient: LinearGradient(colors: [
      Color(0xffffffff),
      Color(0xffffffff) ],
    stops: [0,1],),

 
          shape: BoxShape.circle); 
    } 


        if (daypmsSelected) {
        var renk;
           if(isToday){renk=0xff8a4bf9 ;}else{renk=0xffffffff;}
      boxDecoration = BoxDecoration(
    		gradient: LinearGradient(colors: [
      Color(0xffffffff),
      Color(0xffffffff) ],
    stops: [0,1],),

     border: Border.all(
     
            color: Color(renk),
            width: 1.5,
          ),
          shape: BoxShape.circle);           
                                   
    } 

        if (daypmsfrstSelected) {

          var renk;
           if(isToday){renk=0xff8a4bf9 ;}else{renk=0xffffffff;}
      boxDecoration = BoxDecoration(
       gradient: LinearGradient(colors: [
     Color(0xff8a4bf9),
      Color(0xffd487fb) ],
    stops: [0,1],),
    
     border: Border.all(
     
            color: Color(renk),
            width: 1.5,
          ),
          shape: BoxShape.circle 
        
        
        );
    } 


        if (dayovlfrstSelected) {
          var renk;
           if(isToday){renk=0xff259cfa ;}else{renk=0xffffffff;}
      boxDecoration = BoxDecoration(gradient: LinearGradient(colors: [
     Color(0xff68e0cf),
      Color(0xff259cfa) ],
    stops: [0,1]),


     border: Border.all(
            color: Color(renk),
            width: 1.5,
          ),
          shape: BoxShape.circle);    
    } 

    
    return Expanded(
        child: GestureDetector(
          child: Container(
              height: 40.0,
              decoration: boxDecoration,
              child: Center(
                  child: Text(
                    "${date.day}",

                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor,                
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
 
                    ),
                  ))),
          onTap: handleTap,
          behavior: HitTestBehavior.translucent,
        ));
  }

  void handleTap() {
    if (onTap != null) {
      onTap(date);
    }

   // calendarroState.setSelectedDate(date);
   // calendarroState.setCurrentDate(date);
  }
}
