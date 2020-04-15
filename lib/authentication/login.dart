import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/authentication/loading.dart';
import 'package:peddazz/models/user_model.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginBody(),
    );
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
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height*0.95,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height*0.25,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.dark, AppColor.appBar
                        ],
                        tileMode: TileMode.mirror
                      ),
//                    borderRadius: BorderRadius.only(
//                      bottomLeft: Radius.circular(72),
//                      bottomRight: Radius.circular(72)
//                    )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height*0.04,
                          left: MediaQuery.of(context).size.width*0.08
                      ),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height*0.026,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: MediaQuery.of(context).size.height*0.2,
//                  left: MediaQuery.of(context).size.width*0.03,
//                  right: MediaQuery.of(context).size.width*0.03,
                    child: Center(
                      child: Container(
                          height: MediaQuery.of(context).size.height*0.75,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(42),
                              topRight: Radius.circular(42)
                            ),
                            color: Colors.white
                          ),
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height*0.05,
                                left: MediaQuery.of(context).size.width*0.08
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height*0.08,
                                left: MediaQuery.of(context).size.width*0.04,
                                right: MediaQuery.of(context).size.width*0.04
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.8,
                                child: Center(
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: eMail,
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.mail_outline,
                                        color: AppColor.primary,
                                      ),
                                      labelText: 'E-mail'
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height*0.05,
                                  left: MediaQuery.of(context).size.width*0.04,
                                  right: MediaQuery.of(context).size.width*0.04
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.8,
                                child: Center(
                                  child: TextFormField(
                                    controller: passWord,
                                    decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.lock_outline,
                                          color: AppColor.primary,
                                        ),
                                        labelText: 'Password',
                                      suffixIcon: IconButton(
                                        icon: Icon(CupertinoIcons.eye_solid),
                                        onPressed: _toggle,
                                      ),
                                    ),
                                    obscureText: _obscureText,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height*0.1,
                                left: MediaQuery.of(context).size.width*0.05,
                                right: MediaQuery.of(context).size.width*0.05
                              ),
                              child: Center(
                                child: RaisedButton(
                                  color: AppColor.primary,
                                  onPressed: () async {
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    bool activeConnection = false;
                                    try {
                                      final result = await InternetAddress.lookup("googl.com");
                                      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                        activeConnection = true;
                                      }
                                    } catch (e) {
                                      activeConnection = false;
                                    }
                                    if(activeConnection == true) {
                                      await _changeLoadingVisible();
                                      bool successful = await Provider.of<UserModel>(context,listen: false).signInWithEmail(email: eMail.text.trim(),password: passWord.text.trim());
                                      if(successful==false){
                                        await _changeLoadingVisible();
                                      }
                                    } else {
                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("No internet connection")));
                                    }
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height*0.02,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white
                                    ),
                                  ),
                                  shape: StadiumBorder(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width*0.06,
                                    vertical: MediaQuery.of(context).size.width*0.03
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.2,
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
                                      style: TextStyle(color: AppColor.primary),
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
              ),
            )
          ],
        ),
      ),
      inAsyncCall: loadingVisible,
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      loadingVisible = !loadingVisible;
    });
  }
}
