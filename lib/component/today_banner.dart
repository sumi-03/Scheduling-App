import 'package:flutter/material.dart';
import 'package:my_project/const/colors.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;

  const TodayBanner({
    required this.selectedDate,
    required this.count,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle1 = TextStyle(
        fontWeight: FontWeight.w800, color: deepGreenColor, fontSize: 13.0);
    final textStyle2 = TextStyle(
        fontWeight: FontWeight.w800, color: blackColor, fontSize: 15.0);
    final textStyle3 = TextStyle(
        fontWeight: FontWeight.w800, color: deepPinkColor, fontSize: 25.0);

    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'My Schedules',
              style: textStyle1,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Text(
              '${selectedDate.year}년                                          ',
              style: textStyle2,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              '${selectedDate.month}월 ${selectedDate.day}일',
              style: textStyle2,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Text(
              '$count',
              style: textStyle3,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
