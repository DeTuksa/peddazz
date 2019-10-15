import 'package:flutter/material.dart';
import 'package:peddazz/authentication/login.dart';
import 'package:peddazz/authentication/signup.dart';
import 'package:peddazz/chats/chats.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        "chats": (context) => ChatUsers(),
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
              return MyHomePage();
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
                        child: Image.asset('images/Dee.jpg'),
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
              onTap: null,
            ),
            ListTile(
              leading: Icon(Icons.folder_shared),
              title: Text('My Files'),
              onTap: null,
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.book),
              title: Text('Notes'),
              onTap: null
            ),
            ListTile(
              leading: Icon(Icons.mic),
              title: Text('Recordings'),
              onTap: null
            ),
            Divider(
              height: 33,
            ),
            ListTile(
              title: Text('Settings'),
              trailing: Icon(Icons.settings),
              onTap: null,
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