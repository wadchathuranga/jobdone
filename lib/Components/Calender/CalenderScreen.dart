import 'dart:async';
import 'dart:developer' as developer;
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../Databases/bargeAllocation_queries.dart';
import '../../services/jobService.dart';
import '../job_screen/JobScreen.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  List<dynamic> jobsList = [];
  bool agenda = true;

  @override
  void initState() {
    super.initState();

    getBargeAllocationData();

    //get data from DB after saving
    getBargeAllocationForCalenderFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: jobsList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SfCalendar(
                view: CalendarView.month,
                dataSource: JobDataSource(_getDataSource()),
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  // agendaStyle: AgendaStyle(),
                  // showTrailingAndLeadingDates: false,
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                ),
                onTap: (CalendarTapDetails details) {
                  print(details.targetElement);
                  if (details.targetElement == CalendarElement.calendarCell) {
                    // setState(() {
                    //
                    // });
                  } else if (details.targetElement ==
                      CalendarElement.appointment) {
                    final Job job = details.appointments!.first;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Tapped on appointment: ${job.eventName}'),
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JobScreen()),
                    );
                  }
                },
              ),
      ),
    );
  }

  void getBargeAllocationData() async {
    var jobAllocationList = jsonDecode(
        await JobApiService.getBargeAllocationListFromServer())['result'];
    setState(() {});

    BargeAllocationDB.saveBargeAllocationListToDB(jobAllocationList);
  }

  void getBargeAllocationForCalenderFromDB() async {
    jobsList = await BargeAllocationDB.getBargeAllocationListFromDB();
    setState(() {});
  }

  List<Job> _getDataSource() {
    final List<Job> Jobs = <Job>[];
    final DateTime today = DateTime.now().add(const Duration(days: 3));

    for (var job in jobsList) {
      Jobs.add(
        Job(
          '${job['jobNo']} - ${job['vesselName']}',
          DateTime(
              DateTime.parse(job['assignedFromDateTime']).year,
              DateTime.parse(job['assignedFromDateTime']).month,
              DateTime.parse(job['assignedFromDateTime']).day,
              0,
              0,
              0),
          DateTime(
              DateTime.parse(job['assignedToDateTime']).year,
              DateTime.parse(job['assignedToDateTime']).month,
              DateTime.parse(job['assignedToDateTime']).day,
              11,
              59,
              0),
          const Color(0xFF0F8644),
          false,
        ),
      );
    }

    // Jobs.add(
    //   Job(
    //     'jobsList',
    //     DateTime(today.year, today.month, today.day - 2, 0, 0, 0),
    //     DateTime(today.year, today.month, today.day - 2, 0, 30, 0),
    //     const Color(0xFF0F8644),
    //     false,
    //   ),
    // );
    //
    // Jobs.add(
    //   Job(
    //       'JOB4',
    //       DateTime(today.year, today.month, today.day, 0, 0, 0),
    //       DateTime(today.year, today.month, today.day, 23, 59, 0),
    //       const Color(0xFF0F8644),
    //       false),
    // );
    //
    // Jobs.add(
    //   Job(
    //       'JOB5',
    //       DateTime(today.year, today.month, today.day, 0, 0, 0),
    //       DateTime(today.year, today.month, today.day, 23, 59, 0),
    //       const Color(0xFF0F8644),
    //       false),
    // );
    //
    // Jobs.add(
    //   Job(
    //       'JOB7',
    //       DateTime(today.year, today.month, today.day, 0, 0, 0),
    //       DateTime(today.year, today.month, today.day, 23, 59, 0),
    //       const Color(0xFF0F8644),
    //       false),
    // );
    return Jobs;
  }
}

class JobDataSource extends CalendarDataSource {
  JobDataSource(List<Job> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Job {
  Job(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
