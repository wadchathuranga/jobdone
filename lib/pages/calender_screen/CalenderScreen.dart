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
          dataSource: MeetingDataSource(_getDataSource()),
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
              final Meeting meeting = details.appointments!.first;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Tapped on appointment: ${meeting.eventName}')),
              );
            }
          },
        ),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now().add(const Duration(days: 3));
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
      Meeting(
          'Conference',
          DateTime(today.year, today.month, today.day + 1, 9, 0, 0),
          startTime.add(const Duration(hours: 1)),
          const Color(0xFF0F8644),
          false),
    );
    meetings.add(
      Meeting('Meeting', startTime, endTime, const Color(0xFF0F8644), false),
    );
    meetings.add(
      Meeting('Meeting', startTime, endTime, const Color(0xFF0F8644), false),
    );
    meetings.add(
      Meeting('Meeting', startTime, endTime, const Color(0xFF0F8644), false),
    );
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
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

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
