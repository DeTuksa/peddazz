import 'package:flutter/material.dart';
import 'package:peddazz/authentication/login.dart';
import 'package:peddazz/authentication/signup.dart';
import 'package:peddazz/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      ),
      home: Login(title: 'PEDDAZ'),
      debugShowCheckedModeBanner: false,
      routes: {
        "login": (context) => Login(),
        "sign_up": (context) => SignUp(),
        "home": (context) => HomeScreen(),
      },
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