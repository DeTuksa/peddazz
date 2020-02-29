import 'package:flutter/material.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/planner/table_calender.dart';

class PlannerHome extends StatefulWidget {
  @override
  _PlannerHomeState createState() => _PlannerHomeState();
}

class _PlannerHomeState extends State<PlannerHome> {

  final Duration duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
            children: <Widget>[
              AnimatedPositioned(
                duration: duration,
                top: height*0.6,
                bottom: 0,
                left: 0,
                right: 0,
                child: Material(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  color: AppColor.dark,
                ),
              ),
              PlannerCalender(),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(
          Icons.add,
          color: AppColor.dark,
        ),
        backgroundColor: AppColor.light,
      ),
    );
  }
}