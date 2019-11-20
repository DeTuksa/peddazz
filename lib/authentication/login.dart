import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peddazz/main.dart';
import 'package:peddazz/authentication/signup.dart';
import 'package:peddazz/authentication/loading.dart';
import 'dart:io';

GlobalKey<CustomCircularProgressIndicatorState> indicatorKey = new GlobalKey();

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            MyApp.user = snapshots.data;
            return Container();
          } else {
            return Scaffold(
              body: LoginBody(),
            );
          }
        });
  }
}

class LoginBody extends StatefulWidget {
  @override
  State createState() => LoginBodyState();
}

class LoginBodyState extends State<LoginBody> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController eMail = new TextEditingController();
  final TextEditingController passWord = new TextEditingController();

  bool loadingVisible = false;
  bool autoValidate = false;

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Container(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 140,
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextFormField(
                              controller: eMail,
                              decoration: InputDecoration(
                                icon: Icon(Icons.mail_outline,
                                    color: Colors.deepPurple),
                                hintText: "Enter school e-mail",
                                labelText: "E-mail",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 18.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20,
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextFormField(
                              controller: passWord,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.lock_outline,
                                      color: Colors.deepPurple),
                                  hintText: "Enter password",
                                  labelText: "Password",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 18.0),
                                  suffixIcon: IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: _toggle)),
                              obscureText: _obscureText,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 40.0,
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: CustomCircularProgressIndicator(
                            key: indicatorKey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 80.0,
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: Center(
                            child: RaisedButton(
                              color: Colors.deepPurple,
                              onPressed: () async {
                                FocusScope.of(context).requestFocus(new FocusNode());
                                bool activeConnection = false;
                                try {
                                  final result = await InternetAddress.lookup(
                                      "google.com");
                                  if (result.isNotEmpty &&
                                      result[0].rawAddress.isNotEmpty) {
                                    activeConnection = true;
                                  }
                                } catch (e) {
                                  activeConnection = false;
                                }
                                if (activeConnection == true) {
                                  signInWithEmail();
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("No internet connection"),
                                  ));
                                }
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                              shape: StadiumBorder(),
                              disabledColor: Colors.deepPurple,
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.06,
                                vertical:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 80.0,
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have an account?"),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed("sign_up");
                                },
                                child: Text(
                                  " Signup",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
      inAsyncCall: loadingVisible,
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      loadingVisible = !loadingVisible;
    });
  }

  void signInWithEmail() async {
    try {
      await _changeLoadingVisible();
      MyApp.user = null;
      MyApp.user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: eMail.text.trim(), password: passWord.text.trim()))
          .user;
    } catch (e) {
      print(e.toString());
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("username or password incorrect"),
      ));
    } finally {
      if (MyApp.user == null) {
        await _changeLoadingVisible();
        indicatorKey.currentState.setState(() {
          indicatorKey.currentState.opacity = 0;
        });
      }
      //Scaffold.of(context)
      //  .showSnackBar(SnackBar(content: Text("error logging you in")));
    }
  }
}
