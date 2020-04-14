import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peddazz/authentication/login.dart';
import 'package:peddazz/authentication/signup.dart';
import 'package:peddazz/chats/chats.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/feed/feed_page.dart';
import 'package:peddazz/feed/writeup_page.dart';
//import 'package:peddazz/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peddazz/message_handler.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:peddazz/notes/notescreen.dart';
import 'package:peddazz/planner/planner_home.dart';
import 'package:peddazz/recording/audio_recording.dart';
import 'package:peddazz/settings/help.dart';
import 'package:peddazz/storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:peddazz/settings/settings.dart';
import 'chats/users.dart';

GlobalKey globalKey = new GlobalKey();

final Color backgroundColor = Color(0xFF4A4A58);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static String baseDirGlobal;
  static FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
      title: 'PEDDAZ',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColorDark: Color(0x2E2633),
        fontFamily: "ZillaSlab",
//        iconTheme: IconThemeData(
//          color: AppColor.dark
//        ),
        primaryIconTheme: IconThemeData(
          color: AppColor.dark
        ),
//        accentIconTheme: IconThemeData(
//          color: AppColor.dark
//        )

      ),
      home: handleCurrentScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        "login": (context) => Login(),
        "sign_up": (context) => SignUp(),
        "home": (context) => MyHomePage(),
        "chatPage": (context) => ChatUsers(),
        "chats": (context) => UsersDisplay(),
        "feed": (context) => FeedPage(),
        "write": (context) => PenThoughts(),
        "settings": (context) => Settings(),
        "audio_recording": (context) => AudioRecording(),
        "files": (context) => Storage(),
        "notes":(context) => NotesScreen(),
        "planner":(context) => PlannerHome(),
        "help": (context) => Help()
      },
    ),
  }

  Widget handleCurrentScreen() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else if (snapshots.hasData) {
          MyApp.user = snapshots.data;
          return StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection("user")
                .document(MyApp.user.uid)
                .snapshots(),
            builder: (context, snapshots) {
              if (!snapshots.hasData) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshots.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return MessageHandler(
                child: MyHomePage(),
              );
            },
          );
        } else {
          return Login();
        }
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  bool isCollapsed = true;
  final Duration duration = Duration(milliseconds: 300);
  AnimationController controller;
  Animation<double> scaleAnimation;
  Animation<double> menuAnimation;
  Animation<Offset> slideAnimation;

  @override
  void initState()
  {
    super.initState();
    requestAudioPermission();
    requestStoragePermission();
    controller = AnimationController(vsync: this, duration: duration);
    scaleAnimation = Tween<double>(begin: 1, end: 1).animate(controller);
    menuAnimation = Tween<double>(begin: 0.5, end: 1).animate(controller);
    slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  requestAudioPermission() async
  {

    Map<PermissionGroup, PermissionStatus> microphone = await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
    return microphone;
  }

  requestStoragePermission() async
  {
    Map<PermissionGroup, PermissionStatus> storage = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    return storage;
  }

  File profile;
  File image;


  Widget menu(context) {
    return SlideTransition(
      position: slideAnimation,
      child: ScaleTransition(
        scale: menuAnimation,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: Icon(FontAwesomeIcons.school),
                  title: Text("Overview"),
                  onTap: () {
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.clipboard),
                  title: Text("Planner"),
                  onTap: () {
                    Navigator.of(context).pushNamed("planner");
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.paperPlane),
                  title: Text("Chats"),
                  onTap: () {
                    Navigator.of(context).pushNamed("chats");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.trending_up),
                  title: Text("Feed"),
                  onTap: () {
                    Navigator.of(context).pushNamed("feed");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.folder_shared),
                  title: Text("My Files"),
                  onTap: () {
                    Navigator.of(context).pushNamed("files");
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.book),
                  title: Text("Notes"),
                  onTap: () {
                    Navigator.of(context).pushNamed("notes");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.mic),
                  title: Text("Recordings"),
                  onTap: () {
                    Navigator.of(context).pushNamed("audio_recording");
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PEDDAZZ', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {
          setState(() {
            if(isCollapsed)
              controller.forward();
            else
              controller.reverse();

            isCollapsed = !isCollapsed;
          });
        }),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              CupertinoIcons.settings,
              color: AppColor.icon,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "settings");
            },
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: Stack(
        children: <Widget>[
          menu(context),
              AnimatedPositioned(
                top: 0,
                bottom: 0,
                left: isCollapsed ? 0 : 0.6 * MediaQuery.of(context).size.width,
                right: isCollapsed ? 0 : -0.4 * MediaQuery.of(context).size.width,
                duration: duration,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: Material(
                    elevation: isCollapsed ? 0 : 8,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12)
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          left: 10, right: 10
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 150,
                              child: PageView(
                                controller: PageController(viewportFraction: 0.8),
                                scrollDirection: Axis.horizontal,
                                pageSnapping: true,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue.shade700,
                                      borderRadius: BorderRadius.all(Radius.circular(24)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(24)),
                                      child: Image.asset(
                                          "images/girl_planning.jpeg",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.limeAccent.shade700,
                                        borderRadius: BorderRadius.all(Radius.circular(24))
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(24)),
                                      child: Image.asset(
                                        "images/connect.png",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.orangeAccent.shade700,
                                        borderRadius: BorderRadius.all(Radius.circular(24))
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(24)),
                                      child: Image.asset(
                                        "images/brainstorm.jpeg",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
      ),
    );
  }
}