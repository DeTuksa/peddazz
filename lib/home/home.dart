import 'package:peddazz/home/drawer_controller.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:peddazz/home/home_drawer.dart';
import 'package:peddazz/chats/chats.dart';

class HomeScreen extends StatefulWidget
{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;

  @override
  void initState()
  {
    drawerIndex = DrawerIndex.Overview;
    screenView = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: prefix0.DrawerController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            animeController: (AnimationController animationController) {
              sliderAnimationController = animationController;
            },
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.Overview) {
        setState(() {
          screenView = null;
        });
      } else if (drawerIndex == DrawerIndex.Chats) {
        setState(() {
          screenView = ChatUsers();
        });
      } else if (drawerIndex == DrawerIndex.Feed) {
        setState(() {
          screenView = null;
        });
      } else if (drawerIndex == DrawerIndex.Planner) {
        setState(() {
          screenView = null;
        });
      } else if (drawerIndex == DrawerIndex.Files) {
        setState(() {
          screenView = null;
        });
      } else if(drawerIndex == DrawerIndex.Timetable) {
        setState(() {
          screenView = null;
        });
      } else if(drawerIndex == DrawerIndex.Recordings) {
        setState(() {
          screenView = null;
        });
      }
    }
  }
}