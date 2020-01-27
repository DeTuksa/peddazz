import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peddazz/colors.dart';
import 'loading.dart';
import 'package:peddazz/main.dart';
import 'dart:io';


//FIXME
GlobalKey<CustomCircularProgressIndicatorState> indicatorKey = new GlobalKey();

class SignUp extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController firstName = new TextEditingController();
  final TextEditingController middleName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController eMail = new TextEditingController();
  final TextEditingController passWord = new TextEditingController();
  bool loadingVisible = false;
  bool autoValidate = false;
  File image;
  File profile;
  String uploadImageURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingScreen(
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
                      height: MediaQuery.of(context).size.height * 0.95,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [AppColor.dark, AppColor.appBar],
                            tileMode: TileMode.mirror),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height*0.04,
                            left: MediaQuery.of(context).size.width*0.08
                        ),
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height*0.026,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.14,
                      child: Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(42),
                                  topRight: Radius.circular(42)),
                              color: Colors.white
                          ),
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height*0.02,
                                  left: MediaQuery.of(context).size.width*0.05,
                                  right: MediaQuery.of(context).size.width*0.05
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.28,
                                      child: TextFormField(
                                        validator: (value) {
                                          if(value.isEmpty) {
                                            return "Empty field";
                                          }
                                          return null;
                                        },
                                        controller: firstName,
                                        style: TextStyle(
                                          fontSize: 18
                                        ),
                                        decoration: InputDecoration(
                                          labelText: "First Name"
                                        ),
                                      ),
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width*0.28,
                                      child: TextFormField(
                                        validator: (value) {
                                          if(value.isEmpty) {
                                            return "Empty field";
                                          }
                                          return null;
                                        },
                                        controller: middleName,
                                        style: TextStyle(
                                            fontSize: 18
                                        ),
                                        decoration: InputDecoration(
                                            labelText: "Middle Name"
                                        ),
                                      ),
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width*0.28,
                                      child: TextFormField(
                                        validator: (value) {
                                          if(value.isEmpty) {
                                            return "Empty field";
                                          }
                                          return null;
                                        },
                                        controller: lastName,
                                        style: TextStyle(
                                            fontSize: 18
                                        ),
                                        decoration: InputDecoration(
                                            labelText: "Last Name"
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height*0.03,
                                  left: MediaQuery.of(context).size.width*0.05,
                                  right: MediaQuery.of(context).size.width*0.05
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.5,
                                      child: TextFormField(
                                        validator: (value) {
                                          if(value.isEmpty) {
                                            return "Empty field";
                                          }
                                          return null;
                                        },
                                        controller: eMail,
                                        style: TextStyle(
                                          fontSize: 18
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "example.example",
                                          hintStyle: TextStyle(
                                            color: Colors.grey
                                          )
                                        ),
                                      ),
                                    ),

                                    Text(
                                      "@st.futminna.edu.ng",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height*0.03,
                                    left: MediaQuery.of(context).size.width*0.05,
                                    right: MediaQuery.of(context).size.width*0.05
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.8,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Phone Number"
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height*0.03,
                                    left: MediaQuery.of(context).size.width*0.05,
                                    right: MediaQuery.of(context).size.width*0.05
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.8,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "Department"
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height*0.03,
                                    left: MediaQuery.of(context).size.width*0.05,
                                    right: MediaQuery.of(context).size.width*0.05
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.8,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "Level"
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height*0.03,
                                    left: MediaQuery.of(context).size.width*0.05,
                                    right: MediaQuery.of(context).size.width*0.05
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.8,
                                  child: TextFormField(
                                    controller: passWord,
                                    validator: (value) {
                                      if(value.isEmpty) {
                                        return "Empty field";
                                      }
                                      return null;
                                    },
                                    style: TextStyle(fontSize: 18),
                                    decoration: InputDecoration(
                                        labelText: "Password"
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height*0.07,
                                    left: MediaQuery.of(context).size.width*0.05,
                                    right: MediaQuery.of(context).size.width*0.05
                                ),

                                child: Center(
                                  child: RaisedButton(
                                    color: AppColor.primary,
                                    onPressed: () async {
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      if(formKey.currentState.validate()) {
                                        bool isSuccessful = await signUpWithEmail();
                                        if (isSuccessful == true) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    child: Text(
                                        "Sign up",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width*0.06,
                                      vertical: MediaQuery.of(context).size.width*0.03
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height*0.05,
                                    left: MediaQuery.of(context).size.width*0.05,
                                    right: MediaQuery.of(context).size.width*0.05
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Already have an account?"),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        " Login",
                                        style: TextStyle(
                                          color: AppColor.primary
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        inAsyncCall: loadingVisible,
      ),
    );
  }

  Future<void> changeLoadingVisible() async {
    setState(() {
      loadingVisible = !loadingVisible;
    });
  }

  Future<bool> signUpWithEmail() async {
    bool signUpSuccessful = false;
    try {
      await changeLoadingVisible();
      MyApp.user = null;
      MyApp.user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: eMail.text.trim() + '@st.futminna.edu.ng',
        password: passWord.text.trim(),
      ))
          .user;
    } catch (e) {
      print(e.toString());
    } finally {
      if (MyApp.user != null) {
        signUpSuccessful = true;
        Record record = new Record(
            userID: MyApp.user.uid,
            firstName: firstName.text,
            middleName: middleName.text,
            lastName: lastName.text,
            email: eMail.text.trim() + "@st.futminna.edu.ng");

        try {
          Firestore.instance.runTransaction((Transaction transaction) async {
            await Firestore.instance
                .collection("user")
                .document(record.userID)
                .setData(record.toJson());
          });

          await MyApp.user.sendEmailVerification();
        } catch (e) {}
        //i would send a verification email here
        // and take the user to the login page
      } else {
        await changeLoadingVisible();
        indicatorKey.currentState.setState(() {
          indicatorKey.currentState.opacity = 0;
        });
      }
    }
    return signUpSuccessful;
  }
}

class Record {
  String userID;
  String firstName;
  String lastName;
  String email;
  String middleName;

  Record(
      {this.userID,
      this.middleName,
      this.lastName,
      this.firstName,
      this.email});

  Map<String, dynamic> toJson() {
    return {
      "userID": userID,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "middleName": middleName,
    };
  }
}

class CustomCircularProgressIndicator extends StatefulWidget {
  CustomCircularProgressIndicator({Key key}) : super(key: key);
  @override
  State createState() => CustomCircularProgressIndicatorState();
}

class CustomCircularProgressIndicatorState
    extends State<CustomCircularProgressIndicator> {
  double opacity = 0;
  @override
  void initState() {
    super.initState();
    opacity = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(Colors.deepPurpleAccent),
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}
