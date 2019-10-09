import 'package:flutter/material.dart';
import 'package:peddazz/authentication/login.dart';
import 'package:peddazz/authentication/signup.dart';
import 'package:peddazz/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        "home": (context) => HomeScreen(),
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
              return HomeScreen();
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
    return Scaffold();
  }
}