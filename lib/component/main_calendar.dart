import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:my_project/const/colors.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  final DateTime focusedDate;

  MainCalendar(
      {required this.onDaySelected,
      required this.selectedDate,
      required this.focusedDate});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      onDaySelected: onDaySelected,
      // selectedDayPredicate는 캘린더에 표시된 각 날짜가
      // selectedDate와 일치하는지 확인하여
      // 선택된 날짜를 강조하거나 표시하는 역할.
      selectedDayPredicate: (date) =>
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,

      firstDay: DateTime(1900, 1, 1),
      lastDay: DateTime(3000, 1, 1),
      focusedDay: focusedDate,
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        selectedTextStyle: TextStyle(color: whiteColor),
        selectedDecoration: BoxDecoration(
          color: deepPinkColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
