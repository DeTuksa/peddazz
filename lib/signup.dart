import 'package:flutter/material.dart';
import 'loading.dart';


class SignUp extends StatefulWidget
{
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp>
{
  final formKey = GlobalKey<FormState>();

  final TextEditingController firstName = new TextEditingController();
  final TextEditingController middleName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController eMail = new TextEditingController();
  final TextEditingController passWord = new TextEditingController();
  final TextEditingController retypePassword = new TextEditingController();
  bool loadingVisible = false;
  bool autoValidate = false;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: LoadingScreen(
        child: Form(
          key: formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20.0),
                              child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                            ),
                            Padding(
                                padding: EdgeInsets.only
                                  (
                                    top: 40,
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.05
                                ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.28,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Empty field";
                                        }
                                      return null;
                                    },
                                      controller: firstName,
                                      style: TextStyle(fontSize: 18.0),
                                      cursorColor: Colors.deepPurple,
                                      decoration: InputDecoration(
                                        hintText: "First Name",
                                        hintStyle: TextStyle(
                                          color: Colors.grey
                                        )
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.28,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Empty field";
                                          }
                                        return null;
                                      },
                                      controller: middleName,
                                      style: TextStyle(fontSize: 18.0),
                                      cursorColor: Colors.deepPurple,
                                      decoration: InputDecoration(
                                          hintText: "Middle Name",
                                          hintStyle: TextStyle(
                                              color: Colors.grey
                                          )
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.28,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Empty field";
                                          }
                                        return null;
                                      },
                                      controller: lastName,
                                      style: TextStyle(fontSize: 18.0),
                                      cursorColor: Colors.deepPurple,
                                      decoration: InputDecoration(
                                          hintText: "Last Name",
                                          hintStyle: TextStyle(
                                              color: Colors.grey
                                          )
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 40.0,
                                left: MediaQuery.of(context).size.width*0.05,
                                right: MediaQuery.of(context).size.width*0.05,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.5,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Empty field";
                                          }
                                        return null;
                                      },
                                      controller: eMail,
                                      style: TextStyle(
                                        fontSize: 18.0
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "example.example",
                                        hintStyle: TextStyle(
                                          color: Colors.grey
                                        )
                                      ),
                                    ),
                                  ),
                                  Text("@st.futminna.edu.ng",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey
                                  ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 40.0,
                                  left: MediaQuery.of(context).size.width*0.05,
                                  right: MediaQuery.of(context).size.width*0.05
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                child: TextFormField(
                                  validator: (value) {
                                        if (value.isEmpty) {
                                          return "Empty field";
                                          }
                                        return null;
                                      },
                                  controller: passWord,
                                  style: TextStyle(fontSize: 18.0),
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          color: Colors.grey
                                      ),
                                  ),
                                  obscureText: true,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 120.0,
                                  left: MediaQuery.of(context).size.width*0.05,
                                  right: MediaQuery.of(context).size.width*0.05),
                              child: Center(
                                child: RaisedButton(
                                  color: Colors.deepPurple,
                                  onPressed: null,
                                  child: Text(
                                    "Signup",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  disabledColor: Colors.deepPurple,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width*0.06,
                                    vertical: MediaQuery.of(context).size.width*0.03,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 40.0,
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
                                      Navigator.of(context).pushNamed("login");
                                    },
                                    child: Text(
                                      " Login",
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
/*
  Future<bool> signUpWithEmail() async {
    bool signUpSuccessful = false;
    try {
      MyApp.user = null;
      MyApp.user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: eMail.text.trim() + '@st.futminna.edu.ng',
          password: passWord.text.trim())) as FirebaseUser;
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
            email: eMail.text);

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
        indicatorKey.currentState.setState(() {
          indicatorKey.currentState.opacity = 0;
        });
      }
    }
    return signUpSuccessful;
  }
*/
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