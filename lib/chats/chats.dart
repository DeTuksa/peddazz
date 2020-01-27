import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peddazz/chats/message.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/main.dart';

class ChatUsers extends StatefulWidget {
  static const String id = 'Chat';
  final FirebaseUser user;

  const ChatUsers({Key key, this.user}) : super(key: key);
  @override
  ChatUsersState createState() => ChatUsersState();
}

class ChatUsersState extends State<ChatUsers> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Firestore firestore = Firestore.instance;

  TextEditingController message = TextEditingController();
  ScrollController scroll = ScrollController();

  Future<void> callBack() async {
    print(MyApp.user.email);
    if (message.text.length > 0) {
      String receiverID = ModalRoute.of(context).settings.arguments;
      await firestore
          .collection('user')
          .document(receiverID)
          .collection("messages")
          .add({
        'text': message.text,
        'from': MyApp.user.email,
        'timestamp': Timestamp.now()
      });
      message.clear();
      scroll.animateTo(scroll.position.maxScrollExtent,
          curve: Curves.easeOut, duration: Duration(milliseconds: 300));
    }
  }

  List<Widget> buildMessageWidgets() {
    List<DocumentSnapshot> messages = [];
    for (int x = 0; x < receiverMessages.length; x++) {
      messages.add(receiverMessages[x]);
    }
    for (int x = 0; x < senderMessages.length; x++) {
      messages.add(senderMessages[x]);
    }
    messages.sort((snap1, snap2) {
      Timestamp stamp1 = snap1["timestamp"];
      Timestamp stamp2 = snap2["timestamp"];
      return stamp2.compareTo(stamp1);
    });

    List<Widget> messagesWidget = messages
        .map((doc) => Message(
              from: doc.data['from'],
              text: doc.data['text'],
              person: MyApp.user.email == doc.data['from'],
            ))
        .toList();

    return messagesWidget;
  }

  List<DocumentSnapshot> receiverMessages = [];
  List<DocumentSnapshot> senderMessages = [];
  StreamSubscription receiverSub;
  StreamSubscription senderSub;
  int buildCount = 0;
  @override
  void dispose() {
    super.dispose();
    try {
      receiverSub.cancel();
      senderSub.cancel();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (buildCount == 0) {
      Function getMessages = () async {
        String receiverID = ModalRoute.of(context).settings.arguments;
        String receiversEmail;
        await Firestore.instance
            .collection("user")
            .document(receiverID)
            .get()
            .then((receiverSnapshot) {
          receiversEmail = receiverSnapshot["email"].toString().trim();
        });

        receiverSub=firestore
            .collection("user")
            .document(receiverID)
            .collection("messages")
            .where("from", isEqualTo: MyApp.user.email)
            .snapshots()
            .listen((snap) {
          setState(() {
            receiverMessages = snap.documents;
          });
        });

        senderSub=firestore
            .collection("user")
            .document(MyApp.user.uid)
            .collection("messages")
            .where("from", isEqualTo: receiversEmail)
            .snapshots()
            .listen((snap) {
          setState(() {
            senderMessages = snap.documents;
          });
        });
      };
      getMessages();
    }
    buildCount++;
    return Scaffold(
      backgroundColor: AppColor.dark,
      body: Container(
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.only(
//            topRight: Radius.circular(30),
//            topLeft: Radius.circular(30)
//          )
//        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.06, left: 10, right: 10, bottom: MediaQuery.of(context).size.height*0.02
              ),
              decoration: BoxDecoration(
                color: AppColor.dark
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white60,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }
                      ),

                      Text(
                        "Tuksa Emmanuel",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white60
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.call,
                          color: Colors.white60,
                        ),
                        onPressed: null,
                      ),

                      IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white60,
                        ),
                        onPressed: null,
                      )
                    ],
                  )
                ],
              ),
            ),

            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)
                  ),
                  color: Colors.white
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)
                  ),
                  child: ListView(
                    reverse: true,
                    controller: scroll,
                    children: buildMessageWidgets(),
                  ),
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.photo),
                      iconSize: 24,
                      onPressed: null,
                    ),

                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            height: 1,
                            fontSize: 16
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          maxLines: null,
                          onFieldSubmitted: (value) => callBack(),
                          controller: message,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Enter a message',
                          ),
                        ),
                      ),
                    ),

                    IconButton(
                      icon: Icon(Icons.send),
                      iconSize: 24,
                      onPressed: () {
                        callBack();
                      },
                    )
                  ],
                ))
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


//DO NOT DELETE YET. left this snippet incase we need to revert some changes
//final tempFormerChatImplemetation =Expanded(
//  child: StreamBuilder<QuerySnapshot>(
//    stream: firestore.collection('messages').orderBy('timestamp', descending: false).snapshots(),
//    builder: (context, snapshot) {
//      if(!snapshot.hasData)return Center(
//          child: CustomCircularProgressIndicator()
//      );
//
//      List<DocumentSnapshot> docs = snapshot.data.documents;
//
//      List<Widget> messages = docs.map((doc) => Message(
//        from: doc.data['from'],
//        text: doc.data['text'],
//        person: MyApp.user.email == doc.data['from'],
//      )).toList();
//
//      return ListView(
//        controller: scroll,
//        children: <Widget>[
//          ... messages,
//        ],
//      );
//    },
//  ),
//),
