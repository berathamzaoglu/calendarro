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
   
    bool isToday = DateUtils.isToday(date);
    calendarroState = Calendarro.of(context);

    bool daySelected = calendarroState.isDateSelected(date);
    bool rgldaySelected = calendarroState.isrglDateSelected(date);
    bool ovldaySelected = calendarroState.isovlDateSelected(date);
    bool psmdaySelected = calendarroState.ispsmDateSelected(date);

     var textColor;
     if (ovldaySelected) {
       textColor = Color(0xff8a4bf9);
     } 
     if(rgldaySelected){
     textColor = Color(0xffff4c51);
     }
     if(psmdaySelected){textColor = Color(0xff259cfa);}
    if(daySelected){textColor = Color(0xffffffff);}
      BoxDecoration boxDecoration;
    
    if (daySelected) {    


     boxDecoration = BoxDecoration(
  
    		gradient: LinearGradient(colors: [
      Color(0xffff825f),
      Color(0xffff4c51) ],
    stops: [0,1]),
    
    

    
                /*borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                                     ),*/
                                     
                                     
                                     );           
                                   
    } else if (isToday) {
      //textColor = Colors.white,
      boxDecoration = BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          shape: BoxShape.circle);
      
     
    }



    if (rgldaySelected) {    


     boxDecoration = BoxDecoration(	
       gradient: LinearGradient(
        colors: [
      Color(0xffffffff),
      Color(0xffffffff) ],
      stops: [0,1]),
      
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          shape: BoxShape.circle
      


              /*borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),),*/
                                     );           
                                   
    } else if (isToday) {
      //textColor = Colors.white,
          boxDecoration = BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          shape: BoxShape.circle);
      
     
    }








        if (ovldaySelected) {    


     boxDecoration = BoxDecoration(gradient: LinearGradient(colors: [
     Color(0xffffffff),
     Color(0xffffffff) ],
    stops: [0,1]),


     border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          shape: BoxShape.circle


              /*borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                                     ),*/
                                     
                                     
                                     );           
                                   
    } else if (isToday) {
      //textColor = Colors.white,
      boxDecoration = BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          shape: BoxShape.circle);
      
     
    }















        if (psmdaySelected) {    


    boxDecoration = BoxDecoration(
    		gradient: LinearGradient(colors: [
      Color(0xffffffff),
      Color(0xffffffff) ],
    stops: [0,1],),

     border: Border.all(
     
            color: Colors.white,
            width: 1.0,
          ),
          shape: BoxShape.circle

              /*borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(0.0),
                topRight: const Radius.circular(0.0),
                bottomRight: const Radius.circular(0.0),
                bottomLeft: const Radius.circular(00.0),
                                     ),*/
                                     );           
                                   
    }else if (isToday) {
      //textColor = Colors.white,
        boxDecoration = BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2.0,
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
