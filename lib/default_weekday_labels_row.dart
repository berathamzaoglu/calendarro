import 'package:flutter/widgets.dart';

class CalendarroWeekdayLabelsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("Mon", textAlign: TextAlign.center,
                       
    style: TextStyle(
    fontFamily: 'Poppins',
    color: Color(0xff4a4a4a),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    
    ),

                            
                            
                            ),),
        Expanded(child: Text("Tue", textAlign: TextAlign.center,style: TextStyle(
    fontFamily: 'Poppins',
    color: Color(0xff4a4a4a),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    
    ),)),
        Expanded(child: Text("Wed", textAlign: TextAlign.center,style: TextStyle(
    fontFamily: 'Poppins',
    color: Color(0xff4a4a4a),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    
    ),)),
        Expanded(child: Text("Thu", textAlign: TextAlign.center,style: TextStyle(
    fontFamily: 'Poppins',
    color: Color(0xff4a4a4a),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    
    ),)),
        Expanded(child: Text("Fri", textAlign: TextAlign.center,style: TextStyle(
    fontFamily: 'Poppins',
    color: Color(0xff4a4a4a),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    
    ),)),
        Expanded(child: Text("Sat", textAlign: TextAlign.center,style: TextStyle(
    fontFamily: 'Poppins',
    color: Color(0xff4a4a4a),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    
    ),)),
        Expanded(child: Text("Sun", textAlign: TextAlign.center,style: TextStyle(
    fontFamily: 'Poppins',
    color: Color(0xff4a4a4a),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    
    ),)),
      ],
    );
  }
}
