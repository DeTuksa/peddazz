import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peddazz/chats/call/call.dart';
import 'package:peddazz/chats/call/pickup_screen.dart';
import 'package:peddazz/chats/call/video_call.dart';
import 'package:peddazz/models/user_model.dart';
import 'package:provider/provider.dart';

class PickupLayout extends StatelessWidget {

  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    @required this.scaffold
});

  @override
  Widget build(BuildContext context) {

    final UserModel userModel = Provider.of<UserModel>(context);

    return (userModel !=null && userModel.userData != null) ?
        StreamBuilder<DocumentSnapshot>(
          stream: callMethods.callStream(uid: userModel.userData.userId),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.data != null) {
              Call call = Call.fromMap(snapshot.data.data);

              if(!call.hasDialled) {
                return PickUpScreen(call: call);
              }
            }
            return scaffold;
          },
        )
        : Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
