import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';

class CalendarroDayItem extends StatelessWidget {
  CalendarroDayItem({this.date, this.calendarroState, this.onTap, });

  DateTime date;
  CalendarroState calendarroState;
  DateTimeCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool isWeekend = DateUtils.isWeekend(date);
    var textColor = isWeekend ? Color(0xffffffff) : Color(0xfffffff);
    bool isToday = DateUtils.isToday(date);
    calendarroState = Calendarro.of(context);

    bool daySelected = calendarroState.isDateSelected(date);
    bool rgldaySelected = calendarroState.isrglDateSelected(date);
    bool ovldaySelected = calendarroState.isovlDateSelected(date);
    bool psmdaySelected = calendarroState.ispsmDateSelected(date);
      BoxDecoration boxDecoration;
    
    if (daySelected) {    


     boxDecoration = BoxDecoration(
  
    		gradient: LinearGradient(colors: [
      Color(0xffff825f),
      Color(0xffff4c51) ],
    stops: [0,1]),
 
                                     borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                                     ),);           
                                   
    } else if (isToday) {
      //textColor = Colors.white,
      boxDecoration = BoxDecoration(
    			gradient: LinearGradient(colors: [
      Color(0xff00b300),
      Color(0xff4dff4d) ],
    stops: [0,1],),

          borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                
              ),
         
          
          );
      
     
    }



    if (rgldaySelected) {    


     boxDecoration = BoxDecoration(	gradient: LinearGradient(colors: [
      Color(0xffff825f),
      Color(0xffff4c51) ],
    stops: [0,1]),
                                     borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                                     ),);           
                                   
    } else if (isToday) {
      //textColor = Colors.white,
      boxDecoration = BoxDecoration(
    		gradient: LinearGradient(colors: [
      Color(0xff00b300),
      Color(0xff4dff4d) ],
    stops: [0,1],),

          borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                
              ),
         
          
          );
      
     
    }








        if (ovldaySelected) {    


     boxDecoration = BoxDecoration(	gradient: LinearGradient(colors: [
      Color(0xff8a4bf9),
      Color(0xffd487fb) ],
    stops: [0,1]),
                                     borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                                     ),);           
                                   
    } else if (isToday) {
      //textColor = Colors.white,
      boxDecoration = BoxDecoration(
    		gradient: LinearGradient(colors: [
      Color(0xff00b300),
      Color(0xff4dff4d) ],
    stops: [0,1],),

          borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                
              ),
         
          
          );
      
     
    }















        if (psmdaySelected) {    


     boxDecoration = BoxDecoration(	gradient: LinearGradient(colors: [
      Color(0xff68e0cf),
      Color(0xff259cfa) ],
    stops: [0,1],),
                                     borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                                     ),);           
                                   
    } else if (isToday) {
      //textColor = Colors.white,
      boxDecoration = BoxDecoration(
    		gradient: LinearGradient(colors: [
      Color(0xff00b300),
      Color(0xff4dff4d) ],
    stops: [0,1],),

          borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                
              ),
         
          
          );
      
     
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
                    
    style: TextStyle(
    fontFamily: 'Poppins',
    color: textColor,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,),
                    
                    
                    
                  //  style: TextStyle(color: textColor),
                  ),),),
          onTap: handleTap,
          behavior: HitTestBehavior.translucent,
        ),);
  }

  void handleTap() {
    if (onTap != null) {
      onTap(date);
    }
    calendarroState.setCurrentDate(date);
  }
}
