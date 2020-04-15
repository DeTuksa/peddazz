import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:peddazz/main.dart';
import 'dart:io';
import 'package:overlay_support/overlay_support.dart';
import 'package:peddazz/models/user_model.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    child = widget.child;
    fm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      showSimpleNotification(Text(message['notification']['title']),
          background: Colors.black,
          elevation: 5,
          subtitle: Text(message['notification']['body']),
          slideDismiss: true);
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      showSimpleNotification(Text(message['notification']['title']),
          background: Colors.black,
          elevation: 5,
          subtitle: Text(message['notification']['body']),
          slideDismiss: true);
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      showSimpleNotification(Text(message['notification']['title']),
          background: Colors.black,
          elevation: 5,
          subtitle: Text(message['notification']['body']),
          slideDismiss: true);
    });

    saveDeviceToken() async {
      fcmToken = await fm.getToken();
      if (fcmToken != null) {
        var tokenRef = Firestore.instance
            .collection("user")
            .document(Provider.of<UserModel>(context,listen: false).user.uid)
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
  Widget build(BuildContext context) {
    return child;
  }
}
