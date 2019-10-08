import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peddazz/main.dart';
import 'package:peddazz/authentication/signup.dart';

GlobalKey<CustomCircularProgressIndicatorState> indicatorKey = new GlobalKey();

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController eMail = new TextEditingController();
  final TextEditingController passWord = new TextEditingController();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
                body: Form(
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
                                        left: 20, right: 20, bottom: 20),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.deepPurple),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 140,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: TextFormField(
                                        controller: eMail,
                                        decoration: InputDecoration(
                                          icon: Icon(Icons.mail_outline,
                                              color: Colors.deepPurple),
                                          hintText: "school e-mail",
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 40,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: TextFormField(
                                        controller: passWord,
                                        decoration: InputDecoration(
                                            icon: Icon(Icons.lock_outline,
                                                color: Colors.deepPurple),
                                            hintText: "password",
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18.0),
                                            suffixIcon: IconButton(
                                                icon:
                                                    Icon(Icons.remove_red_eye),
                                                onPressed: _toggle)),
                                        obscureText: _obscureText,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 40.0,
                                      left: MediaQuery.of(context).size.width *
                                          0.05,
                                      right: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    child: CustomCircularProgressIndicator(
                                      key: indicatorKey,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 80.0,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    child: Center(
                                      child: RaisedButton(
                                        color: Colors.deepPurple,
                                        onPressed: () {
                                          indicatorKey.currentState
                                              .setState(() {
                                            indicatorKey.currentState.opacity =
                                                1;
                                            signInWithEmail();
                                          });
                                        },
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                        ),
                                        disabledColor: Colors.deepPurple,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06,
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 80.0,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Don't have an account?"),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed("sign_up");
                                          },
                                          child: Text(
                                            " Signup",
                                            style: TextStyle(
                                                color: Colors.deepPurple),
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
                    )));
          }
        });
  }

  void signInWithEmail() async {
    try {
      MyApp.user = null;
      MyApp.user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: eMail.text.trim(), password: passWord.text.trim()))
          .user;
    } catch (e) {
      print(e.toString());
    } finally {
      if (MyApp.user == null) {
        indicatorKey.currentState.setState(() {
          indicatorKey.currentState.opacity = 0;
        });
      }
      //Scaffold.of(context)
        //  .showSnackBar(SnackBar(content: Text("error logging you in")));
    }
  }
}
