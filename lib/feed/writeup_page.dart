import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/main.dart';

class PenThoughts extends StatefulWidget {
  @override
  _PenThoughtsState createState() => _PenThoughtsState();
}

class _PenThoughtsState extends State<PenThoughts> {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Firestore firestore = Firestore.instance;

  TextEditingController message = TextEditingController();
  ScrollController scroll = ScrollController();

  Future <void> callBack() async
  {
    if(message.text.length > 0) {
      await firestore.collection('Feed').add({
        'text': message.text,
        'from': MyApp.user.displayName,
        'timestamp': Timestamp.now(),
        'likes': 0,
      });

      message.clear();
//      scroll.animateTo(scroll.position.maxScrollExtent, curve: Curves.easeOut,
//          duration: Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(

      child: Scaffold(

        appBar: AppBar(

          backgroundColor: Colors.white,

          leading: Row(

            children: <Widget>[

              IconButton(

                  icon: Icon(Icons.close, color: AppColor.icon,),
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
              )
            ],
          ),
          actions: <Widget>[

            FlatButton(
                onPressed: ()
                {
                  callBack();
                  Navigator.pop(context);
                },

                child: Text(
                  'Send',
                  style: TextStyle(
                      color: AppColor.icon
                  ),
              )
            )
          ],
        ),

        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              cursorColor: AppColor.icon,
              keyboardType: TextInputType.multiline,
              maxLength: 140,
              maxLines: null,
              controller: message,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.icon
                  )
                ),
                labelText: 'Put your thoughts out there...',
                labelStyle: TextStyle(
                  color: AppColor.icon
                ),
                border: OutlineInputBorder()
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Tweet extends StatelessWidget {
  final String username;
  final String handle;
  final String text;
  final Timestamp timestamp;

  const Tweet({Key key, this.handle, this.username, this.text, this.timestamp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Text(
                        'Tuksa',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      '@dt_emmy',
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Text(
                    '5h ago',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                  text
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(icon: Icon(Icons.reply, size: 20,), onPressed: null),
              IconButton(icon: Icon(Icons.repeat, size: 20), onPressed: null),
              IconButton(icon: Icon(Icons.favorite_border, size: 20), onPressed: null),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}