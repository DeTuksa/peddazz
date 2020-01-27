import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      child: Column(
        crossAxisAlignment:
            person ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.only(left: 5, right: 5),
//            child: Text(
//              from,
//              style: TextStyle(color: Colors.grey),
//            ),
//          ),
          Padding(
            padding:
            person ? const EdgeInsets.only(
              left: 50,
            right: 10,
            bottom: 10
            ) : const EdgeInsets.only(
              left: 10,
              right: 50,
              bottom: 10
              ),
            child: Material(
              color: person ? AppColor.login1 : AppColor.appBar,
              borderRadius: person ? BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)
              ) : BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              ) ,
              elevation: 2.0,
              child: Container(
                //width: MediaQuery.of(context).size.width*0.75,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

