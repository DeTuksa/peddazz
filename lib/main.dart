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

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peddazz/message_handler.dart';
import 'package:peddazz/recording/audio_recording.dart';
import 'package:peddazz/storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:peddazz/settings/settings.dart';
import 'chats/users.dart';

GlobalKey globalKey = new GlobalKey();


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static String baseDirGlobal;
  static FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PEDDAZ',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColorDark: Color(0x2E2633),
        
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
        "files": (context) => Storage()
      },
    );
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

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState()
  {
    super.initState();
    requestAudioPermission();
    requestStoragePermission();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PEDDAZZ'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColor.accent
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60.0)),
                        child: GestureDetector(
                          onTap: () async {
                            image = await ImagePicker.pickImage(source: ImageSource.camera);
                            profile = image;
                            print(image.path);
                            if(profile == null)
                            {
                              print("no image");
                            }
                            else
                            {
                              print("Image selected!");
                            }
                            this.setState((){

                            });
                          },
                            child: profile == null ? Icon(Icons.photo_camera) : new Image.file(image),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(MyApp.user.email, style: TextStyle(fontSize: 17, color: Colors.white),),
                    )
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.university),
              title: Text('Overview'),
              onTap: null,
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.clipboardList),
              title: Text('Planner'),
              onTap: null,
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.paperPlane),
              title: Text('Chats'),
              onTap: () {
                Navigator.of(context).popAndPushNamed("chats");
              },
            ),
            ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Feed'),
              onTap: ()
              {
                Navigator.of(context).popAndPushNamed("feed");
              },
            ),
            ListTile(
              leading: Icon(Icons.folder_shared),
              title: Text('My Files'),
              onTap: ()
              {
                Navigator.of(context).popAndPushNamed("files");
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.book),
              title: Text('Notes'),
              onTap: null
            ),
            ListTile(
              leading: Icon(Icons.mic),
              title: Text('Recordings'),
              onTap: ()
                {
                  Navigator.of(context).popAndPushNamed("audio_recording");
                }
            ),
            Divider(
              height: 33,
            ),
            ListTile(
              title: Text('Settings'),
              trailing: Icon(Icons.settings),
              onTap: ()
              {
                Navigator.popAndPushNamed(context, "settings");
              },
            ),
            ListTile(
              title:Text('Sign Out'),
              trailing: Icon(Icons.power_settings_new, color: Colors.red),
              onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
          ],
        ),
      ),
    );
  }
}