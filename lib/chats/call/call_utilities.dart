import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peddazz/chats/call/call.dart';
import 'package:peddazz/models/user_model.dart';

import 'video_call.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dialVideo({UserData from, UserData to, context, String callIs}) async {
    Call call = Call(
      callerId: from.userId,
      callerName: from.firstName + ' ' + from.lastName,
      receiverId: to.userId,
      receiverName: to.firstName + ' ' + to.lastName,
      channelId: Random().nextInt(1000).toString()
    );

    bool callMade = await callMethods.makeVideoCall(call: call);

    call.hasDialled = true;

    if(callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoCallScreen(call: call)
        )
      );
    }
  }

}