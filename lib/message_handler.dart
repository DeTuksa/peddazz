import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:peddazz/main.dart';
import 'dart:io';

String fcmToken;

class MessageHandler extends StatefulWidget {
  final Widget child;
  MessageHandler({this.child});
  @override
  State createState() => MessageHandlerState();
}

class MessageHandlerState extends State<MessageHandler> {
  final Firestore db = Firestore.instance;
  final FirebaseMessaging fm = FirebaseMessaging();
  Widget child;

  @override
  void initState(){
    super.initState();
    child=widget.child;
    fm.configure(
      onMessage: (Map<String,dynamic> message) async{
        print("onMessage: $message");
        Scaffold.of(context).showSnackBar(
          SnackBar(
           content: Text(message['notification']['body']),
            backgroundColor: Colors.black,elevation: 5,
          )
        );
      },
      onResume: (Map<String,dynamic> message) async{
        print("onResume: $message");
        Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(message['notification']['title']),
              backgroundColor: Colors.black,elevation: 5,
            )
        );
      },
      onLaunch: (Map<String,dynamic> message) async{
        print("onLaunch: $message");
        Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(message['notification']['title']),
              backgroundColor: Colors.black,elevation: 5,
            )
        );
      }
    );

    saveDeviceToken() async{
      fcmToken = await fm.getToken();
      if(fcmToken!=null){
        var tokenRef = Firestore.instance
            .collection("user")
            .document(MyApp.user.uid)
            .collection("tokens")
            .document(fcmToken);

        await tokenRef.setData({
          'token': fcmToken,
          "createdAt": FieldValue.serverTimestamp(),
          "platform": Platform.operatingSystem
        });
      }
    }

    saveDeviceToken();
  }

  @override
  Widget build(BuildContext context){
    return child;
  }
}
