import 'package:peddazz/home/drawer_controller.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:peddazz/home/home_drawer.dart';

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
    drawerIndex = DrawerIndex.HOME;
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
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = null;
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = null;
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = null;
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = null;
        });
      } else {
        //do in your way......
      }
    }
  }
}