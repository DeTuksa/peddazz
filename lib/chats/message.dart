import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:peddazz/colors.dart';

class Message extends StatelessWidget {
  final String from;
  final String text;
  final Timestamp timestamp;

  final bool person;

  const Message({Key key, this.from, this.text, this.person, this.timestamp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    child: Container(
      child: Column(
        crossAxisAlignment:
        person ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Bubble(
            color: person ? AppColor.login1 : AppColor.appBar,
            margin: BubbleEdges.only(
                top: 10,
              right: person ? 10 : 0,
              left: person ? 0 : 10
            ),
            nip: person ? BubbleNip.rightTop : BubbleNip.leftTop,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white
              ),
            ),
          )
        ],
      ),
    ),
    );
  }
}

