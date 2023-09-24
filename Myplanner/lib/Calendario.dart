import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'assets/AppStyles.dart';

class Calendario extends StatefulWidget {

  Calendario();

  @override
  _CalendarioState createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Título da Tela'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            focusedDay: DateTime.now(),

            calendarStyle: const CalendarStyle(
              isTodayHighlighted: true,

              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),

              selectedTextStyle: TextStyle(color: Colors.black),
              todayDecoration: BoxDecoration(
                color: AppStyles.highlightColor,
                shape: BoxShape.circle,
              ),

              defaultDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),

              weekendDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),

            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: AppStyles.bodyTextStyle,
              weekdayStyle: AppStyles.bodyTextStyle,
            ),

            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: AppStyles.titleTextStyle,
            ),
          ),

        ],
      ),
    );
  }
}
