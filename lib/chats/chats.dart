import 'dart:async';

import 'package:peddazz/authentication/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peddazz/chats/message.dart';
import 'package:peddazz/main.dart';

class ChatUsers extends StatefulWidget
{
  static const String id = 'Chat';
  final FirebaseUser user;

  const ChatUsers({Key key, this.user}) : super(key: key);
  @override
  ChatUsersState createState() => ChatUsersState();
}

class ChatUsersState extends State<ChatUsers>
{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Firestore firestore = Firestore.instance;

  TextEditingController message = TextEditingController();
  ScrollController scroll = ScrollController();

  Future <void> callBack() async
  {
    print(MyApp.user.email);
    if(message.text.length > 0) {
      await firestore.collection('messages').add({
        'text': message.text,
        'from': MyApp.user.email,
        'timestamp': Timestamp.now()
      });

      message.clear();
      scroll.animateTo(scroll.position.maxScrollExtent, curve: Curves.easeOut, duration: Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData)return Center(
                      child: CustomCircularProgressIndicator()
                      );

                      List<DocumentSnapshot> docs = snapshot.data.documents;

                      List<Widget> messages = docs.map((doc) => Message(
                        from: doc.data['from'],
                        text: doc.data['text'],
                        person: MyApp.user.email == doc.data['from'],
                        )).toList(); 

                  return ListView(
                    controller: scroll,
                    children: <Widget>[
                      ... messages,
                    ],
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      maxLines: null,
                      onFieldSubmitted: (value) => callBack(),
                      controller: message,
                      decoration: InputDecoration(
                        hintText: 'Enter a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24)
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, right: 5),
                  child: FloatingActionButton(
                    child: Icon(Icons.send),
                    onPressed: () {
                      callBack();
                    },
                  ),
                )
              ],
            )
            )
          ],
        ),
      ),
    );
  }
}

//class SendButton extends StatelessWidget
//{
//  final String text;
//  final VoidCallback callback;
//
//  const SendButton({Key key, this.text, this.callback}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context)
//  {
//    return FlatButton(
//      onPressed: callback,
//      child: Text(text),
//      color: Colors.cyan,
//    );
//  }
//}