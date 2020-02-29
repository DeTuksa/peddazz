import 'package:flutter/material.dart';
import 'package:peddazz/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class PlannerCalender extends StatefulWidget {
  @override
  _PlannerCalenderState createState() => _PlannerCalenderState();
}

class _PlannerCalenderState extends State<PlannerCalender> with TickerProviderStateMixin {

  final Duration duration = Duration(milliseconds: 300);

  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController animationController;
  CalendarController calendarController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    calendarController = CalendarController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300)
    );
    animationController.forward();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    return Stack(
      children: <Widget>[
        Container(
          color: AppColor.light,
          height: MediaQuery.of(context).size.height,
        ),
        TableCalendar(
            locale: 'en_US',
            calendarController: calendarController,
            initialCalendarFormat: CalendarFormat.month,
            formatAnimation: FormatAnimation.slide,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            availableGestures: AvailableGestures.all,
            availableCalendarFormats: const {
              CalendarFormat.month: '',
              CalendarFormat.twoWeeks: '',
              CalendarFormat.week: ''
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekdayStyle: TextStyle().copyWith(color: AppColor.login1),
              holidayStyle: TextStyle().copyWith(color: AppColor.login1)
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle().copyWith(color: AppColor.login2)
            ),
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonVisible: false
            ),

            builders: CalendarBuilders(
              selectedDayBuilder: (context, date, _) {
                return FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0).animate(animationController),
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade300,
                      borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(fontSize: 16.0),
                    ),
                  ),
                );
              },

              todayDayBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(fontSize: 16.0),
                  ),
                );
              },

              markersBuilder: (context, date, events, holiday) {
                final children = <Widget>[];

                if (events.isNotEmpty) {
                  children.add(
                    Positioned(
                      right: -2,
                      top: -2,
                      child: buildEventsMarker(date, events),
                    )
                  );
                }

                if(holiday.isNotEmpty) {
                  children.add(
                      Positioned(
                          right: -2,
                          top: -2,
                        child: buildHolidaysMarker(),
                      )
                  );
                }

                return children;
              }
            ),

            onDaySelected: (date, events) {
              _onDaySelected(date, events);
              animationController.forward(from: 0.0);
            },
            onVisibleDaysChanged: _onVisibleDaysChanged,
        ),
        AnimatedPositioned(
          duration: duration,
          top: height*0.55,
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            color: AppColor.dark,
            child: Container(
              //height: 100,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Center(
                    child: IconButton(
                      icon: Icon(Icons.minimize, color: AppColor.light,),
                      onPressed: null,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: calendarController.isSelected(date) ?
            AppColor.primary : calendarController.isToday(date)
          ? AppColor.icon : AppColor.login1
      ),
      width: 16,
      height: 16,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12
          ),
        ),
      ),
    );
  }

  Widget buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: AppColor.icon,
    );
  }

  Widget buildEventList() {
    return ListView(
      children: _selectedEvents.map((_events) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.all(Radius.circular(6))
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(_events.toString()),
          onTap: () => print('$_events tapped'),
        ),
      )).toList(),
    );
  }
}
