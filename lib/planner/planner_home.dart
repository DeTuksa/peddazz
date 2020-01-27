import 'package:flutter/material.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/planner/table_calender.dart';

class PlannerHome extends StatefulWidget {
  @override
  _PlannerHomeState createState() => _PlannerHomeState();
}

class _PlannerHomeState extends State<PlannerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PlannerCalender(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: AppColor.dark,
      ),
    );
  }
}