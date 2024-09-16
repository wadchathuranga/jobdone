import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: JobDataSource(_getDataSource()),
          // monthViewSettings: const MonthViewSettings(showAgenda: true),
          monthViewSettings: const MonthViewSettings(
            showAgenda: true,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          ),
          onTap: (CalendarTapDetails details) {
            print(details.targetElement);
            if (details.targetElement == CalendarElement.calendarCell) {
              final DateTime selectedDate = details.date!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on date: $selectedDate')),
              );
            } else if (details.targetElement == CalendarElement.appointment) {
              final Job job = details.appointments!.first;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Tapped on appointment: ${job.eventName}')),
              );
            }
          },
        ),
      ),
    );
  }

  List<Job> _getDataSource() {
    final List<Job> Jobs = <Job>[];
    final DateTime today = DateTime.now().add(const Duration(days: 3));
    // final DateTime startTime =
    //     DateTime(today.year, today.month, today.day, 9, 0, 0);
    // final DateTime endTime = startTime.add(const Duration(hours: 2));
    Jobs.add(
      Job(
        'Conference',
        DateTime(today.year, today.month, today.day - 2, 9, 0, 0),
        DateTime(today.year, today.month, today.day - 2, 10, 30, 0),
        const Color(0xFF0F8644),
        false,
      ),
    );
    Jobs.add(
      Job(
          'JOB4',
          DateTime(today.year, today.month, today.day, 9, 0, 0),
          DateTime(today.year, today.month, today.day, 10, 0, 0),
          const Color(0xFF0F8644),
          false),
    );
    Jobs.add(
      Job(
          'JOB5',
          DateTime(today.year, today.month, today.day, 10, 0, 0),
          DateTime(today.year, today.month, today.day, 11, 0, 0),
          const Color(0xFF0F8644),
          false),
    );
    Jobs.add(
      Job(
          'JOB7',
          DateTime(today.year, today.month, today.day, 11, 0, 0),
          DateTime(today.year, today.month, today.day, 12, 0, 0),
          const Color(0xFF0F8644),
          false),
    );
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
