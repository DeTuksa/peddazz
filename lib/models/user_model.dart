import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends ChangeNotifier{
  FirebaseUser user;
  UserData userData;
  //stream subscription to monitor authentication states
  StreamSubscription authState;

  //initialize of authState and userData in the userModel constructor
  UserModel(){
    authState = FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      this.user = user;
      notifyListeners();
      getUserData();
    });
    authState.resume();
  }

  void getUserData(){
    if(user!=null){
      Firestore.instance
          .collection('user')
          .document(user.uid)
          .get()
          .then((docSnap){
            userData = UserData.fromJson(docSnap.data);
            notifyListeners();
      });
    }
  }

  Future<bool> signInWithEmail({String email, String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      return false;
    }
    return true;
  }



  Future<bool> signUp(String email, String password, String firstName,
      String lastName, String middleName) async {
    AuthResult result;
    try {
      result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await Firestore.instance
          .collection("user")
          .document(result.user.uid)
          .setData({
        "firstName": firstName,
        "lastName": lastName,
        "middleName": middleName,
        "email": email,
        "userID":result.user.uid
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}


class UserData{
  String firstName;
  String lastName;
  String middleName;
  String userId;
  String email;

  UserData({this.lastName,this.firstName,this.email,this.middleName,this.userId});
  factory UserData.fromJson(Map<String,dynamic> json){
    return UserData(
      firstName: json['firstName'],
      lastName: json['lastName'],
      middleName: json['middleName'],
      userId: json['userID'],
      email: json['email']
    );
  }
}