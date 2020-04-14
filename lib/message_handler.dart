import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:peddazz/main.dart';
import 'dart:io';
import 'package:overlay_support/overlay_support.dart';

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
  Widget build(BuildContext context) {
    return child;
  }
}

class MessageNotification extends StatelessWidget {
  final VoidCallback onReplay;

  const MessageNotification({Key key, this.onReplay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: ListTile(
          leading: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(child: Image.asset('assets/avatar.png'))),
          title: Text('Lily MacDonald'),
          subtitle: Text('Do you want to see a movie?'),
          trailing: IconButton(
              icon: Icon(Icons.reply),
              onPressed: () {
                ///TODO i'm not sure it should be use this widget' BuildContext to create a Dialog
                ///maybe i will give the answer in the future
                if (onReplay != null) onReplay();
              }),
        ),
      ),
    );
  }
}
