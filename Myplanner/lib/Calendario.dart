import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'app_styles.dart';

class Calendario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            focusedDay: DateTime.now(),

            calendarStyle: const CalendarStyle(
              isTodayHighlighted: true,

              defaultTextStyle: AppStyles.bodyTextStyle,
              defaultDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),

              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),

              selectedTextStyle: TextStyle(color: Colors.white),
              
              todayDecoration: BoxDecoration(
                color: AppStyles.highlightColor,
                shape: BoxShape.circle,
              ),

              weekendDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),

            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: AppStyles.subtitleTextStyle,
              weekdayStyle: AppStyles.subtitleTextStyle,
              
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
