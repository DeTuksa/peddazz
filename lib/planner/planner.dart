import 'package:flutter/material.dart';
import 'package:peddazz/chats/call/pickup_layout.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Planner extends StatefulWidget {
  @override
  _PlannerState createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {

  String user;
  UserData userData = UserData();
  List<Meeting> meetings = <Meeting>[];
  CalendarController controller = CalendarController();
  TextEditingController eventController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    eventController.dispose();
    startTimeController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String user = Provider.of<UserModel>(context).userData.userId;
    Firestore.instance.collection('user').document(user).collection('Planner');
    return PickupLayout(
      scaffold: Scaffold(
        body: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(getDataSource()),
          monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            appointmentDisplayCount: 10,
            showAgenda: true
          ),

          cellBorderColor: AppColor.appBar,
          todayHighlightColor: AppColor.background,
          //backgroundColor: AppColor.primary,
          controller: controller,
          timeSlotViewSettings: TimeSlotViewSettings(
            nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday]
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.primary,
          child: Icon(
            Icons.add
          ),
          onPressed: () {
            eventController.clear();
            startTimeController.clear();
            durationController.clear();
            meetingDialog();
          }
        ),
      ),
    );
  }

  Future meetingDialog() {
//    meetings = <Meeting>[];
//    DateTime today = DateTime.now();
//    DateTime startTime = DateTime(today.year, today.month, today.day, 10, 0, 0);
//    DateTime endTime = startTime.add(
//      const Duration(hours: 2)
//    );
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColor.light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6)
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: eventController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Event',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: startTimeController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Start time',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: durationController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Duration',
                    ),
                  ),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'CANCEL'
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                          'ADD'
                      ),
                      onPressed: () {
                        getDataSource();
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

  List<Meeting> getDataSource() {
    //meetings = <Meeting>[];
    String event;
    var start = 10;
    var end = 2;
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, start, 0, 0);
    final DateTime endTime = startTime.add(
       Duration(hours: end)
    );
    meetings.add(Meeting(
      event, AppColor.background, startTime, false, endTime
    ));
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    // TODO: implement getStartTime
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    // TODO: implement getEndTime
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    // TODO: implement getSubject
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    // TODO: implement getColor
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    // TODO: implement isAllDay
    return appointments[index].isAllDay;
  }
}

class Meeting {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  Meeting(this.eventName, this.background, this.from, this.isAllDay, this.to);
}