import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String from;
  final String text;

  final bool person;

  const Message({Key key, this.from, this.text, this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: person ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(from),
          Material(
            color: person ? Colors.teal : Colors.blue,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(text),
            ),
          )
        ],
      ),
    );
  }
}