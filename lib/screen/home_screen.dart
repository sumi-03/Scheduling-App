import 'package:flutter/material.dart';
import 'package:my_project/component/weather_banner.dart';
import 'package:my_project/component/main_calendar.dart';
import 'package:my_project/component/schedule_card.dart';
import 'package:my_project/component/today_banner.dart';
import 'package:my_project/component/schedule_bottom_sheet.dart';
import 'package:my_project/const/colors.dart';
import 'package:my_project/database/drift_database.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkWhitecolor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
            ),
            isScrollControlled: true,
          );
        },
        shape: const CircleBorder(),
        backgroundColor: deepGreenColor,
        foregroundColor: whiteColor,
        child: const Icon(Icons.edit),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 7,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.all(13.0),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(40.0),
                        boxShadow: [
                          BoxShadow(
                            color: lightGrayColor.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: MainCalendar(
                          selectedDate: selectedDate,
                          focusedDate: focusedDate,
                          onDaySelected: onDaySelected,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(13.0),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(40.0),
                              boxShadow: [
                                BoxShadow(
                                  color: lightGrayColor.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: StreamBuilder<List<Schedule>>(
                                stream: GetIt.I<LocalDatabase>()
                                    .watchSchedules(selectedDate),
                                builder: (context, snapshot) {
                                  return TodayBanner(
                                    selectedDate: selectedDate,
                                    count: snapshot.data?.length ?? 0,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(13.0),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(40.0),
                              boxShadow: [
                                BoxShadow(
                                  color: lightGrayColor.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const SingleChildScrollView(
                              child: WeatherInfo(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 6,
              child: Container(
                margin: const EdgeInsets.all(13.0),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(40.0),
                  boxShadow: [
                    BoxShadow(
                      color: lightGrayColor.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: StreamBuilder<List<Schedule>>(
                  stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final schedule = snapshot.data![index];
                        return Dismissible(
                          key: ObjectKey(schedule.id),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (DismissDirection direction) {
                            GetIt.I<LocalDatabase>()
                                .removeSchedule(schedule.id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 1.0, left: 8.0, right: 8.0),
                            child: ScheduleCard(
                              startTime: schedule.startTime,
                              endTime: schedule.endTime,
                              content: schedule.content,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(
      () {
        this.selectedDate = selectedDate;
        this.focusedDate = focusedDate;
      },
    );
  }
}
