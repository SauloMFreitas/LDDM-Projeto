import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'assets/AppStyles.dart';
import 'Lista.dart';

class Calendario extends StatefulWidget {
  Calendario();

  @override
  _CalendarioState createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Calendário'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime(2022),
            lastDay: DateTime(3000),
            focusedDay: _focusedDay,

            calendarStyle: const CalendarStyle(

              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),

              selectedTextStyle: TextStyle(color: Colors.black),

              defaultDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),

              weekendDecoration: BoxDecoration(
                //color: Colors.white,
                //shape: BoxShape.circle,
              ),

              defaultTextStyle: AppStyles.bodyTextStyle,

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

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Lista(dataSelecionada: _selectedDay)
                ),
              );
            },
            selectedDayPredicate: (day) {
              return isSameDay(day, _focusedDay);
            },
          )
        ],
      ),
    );
  }
}