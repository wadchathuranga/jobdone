import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:jobdone/Databases/bargePara_queries.dart';
import 'package:jobdone/Databases/locationAndBerthedType_queries.dart';
import 'package:jobdone/services/bargeParaService.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../Databases/bargeAllocation_queries.dart';
import '../../services/bargeAllocationService.dart';
import '../../services/locationAndBerthedTypeService.dart';
import '../BDN/BDNUploadScreen.dart';
import '../Jobs/JobScreen.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

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
    getBargeParaData();
    getPortLocationsData();
    getBerthedTypesData();

    //get data from DB after saving
    getBargeAllocationForCalenderFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KUMANA - Job Calender'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: SafeArea(
        child:
        // jobsList.isEmpty
        //     ? const Center(child: CircularProgressIndicator())
        //     :
        SfCalendar(
                view: CalendarView.month,
                dataSource: JobDataSource(_getDataSource()),
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayCount: 5,
                  //showAgenda: true,
                  //agendaItemHeight: 50,
                  //agendaStyle: AgendaStyle()
                  //monthCellStyle: MonthCellStyle(),
                  numberOfWeeksInView: 6,
                  //showTrailingAndLeadingDates: false,
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                ),
                onTap: (CalendarTapDetails details) {
                  DateTime cellDate = details.date!; // read cell date
                  print('=====${details.targetElement}');
                  if (details.targetElement == CalendarElement.calendarCell) {
                    List? jobs = details
                        .appointments; // read appointments count on a selected day
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Cell Date of Tapped on Cell: $cellDate \nCount: ${jobs!.length}'),
                      ),
                    );

                    if (details.appointments!.isNotEmpty) {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: JobScreen(selectedDate: cellDate),
                            inheritTheme: true,
                            ctx: context),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           JobScreen(selectedDate: cellDate)),
                      // );
                    }
                  } else if (details.targetElement ==
                      CalendarElement.appointment) {
                    final Job job = details.appointments!.first;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Tapped on appointment: ${job.eventName}'),
                      ),
                    );

                    if (details.appointments!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                JobScreen(selectedDate: cellDate)),
                      );
                    }
                  }
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!context.mounted) return;
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: const BDNUploadScreen(),
              inheritTheme: true,
              ctx: context,
            ),
          );
        }, // Icon inside the FAB
        tooltip: 'BDN List',
        child: const Icon(Icons.library_books), // Tooltip shown when the FAB is long-pressed
      ),
    );
  }

  void getBargeParaData() async {
    var bargePara = jsonDecode(await BargeParaAPIService.getBargeParaDataFromServer())['result'];

    BargeParaDB.saveBargeParaDataToDB(bargePara[0]);
  }

  void getPortLocationsData() async {
    var locationList = jsonDecode(await LocationAndBerthedTypeApiService
        .getPortLocationCodeListFromServer())['result'];

    LocationAndBerthedTypeDB.saveLocationListToDB(locationList);
  }

  void getBerthedTypesData() async {
    var berthedTypeList = jsonDecode(await LocationAndBerthedTypeApiService
        .getBerthedTypeListFromServer())['result'];

    LocationAndBerthedTypeDB.saveBerthedTypeListToDB(berthedTypeList);
  }

  void getBargeAllocationData() async {
    var jobAllocationList = jsonDecode(
        await JobApiService.getBargeAllocationListFromServer())['result'];
    jobsList = jobAllocationList;
    setState(() {});

    BargeAllocationDB.saveBargeAllocationListToDB(jobAllocationList);
  }

  void getBargeAllocationForCalenderFromDB() async {
    jobsList = await BargeAllocationDB.getBargeAllocationListFromDB();
    setState(() {});
  }

  List<Job> _getDataSource() {
    final List<Job> Jobs = <Job>[];

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
              23,
              59,
              0),
          const Color(0xFF0F8644),
          false,
        ),
      );
    }
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
