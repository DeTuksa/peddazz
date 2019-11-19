import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peddazz/feed/writeup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Firestore firestore = Firestore.instance;

  TextEditingController message = TextEditingController();
  ScrollController scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          'Feed'
        ),
        centerTitle: true,
      ),

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                icon: Icon(FontAwesomeIcons.school),
                onPressed: null
            ),
            IconButton(
                icon: Icon(FontAwesomeIcons.search),
                onPressed: null
            ),
            IconButton(
                icon: Icon(FontAwesomeIcons.bell),
                onPressed: null
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
      child: Icon(FontAwesomeIcons.penFancy),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PenThoughts()));
      },
    ),

    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('Feed').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData)return Center(

                  );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs.map((doc) => Feed(
                    snapshot: doc,
                  ) ).toList();

                  return ListView(
                    controller: scroll,
                    children: messages,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Feed extends StatelessWidget{
  final DocumentSnapshot snapshot;
  Feed({this.snapshot});
  @override
  Widget build(BuildContext context){
    Timestamp timestamp = snapshot["timestamp"];
    Duration duration= Timestamp.now().toDate().difference(timestamp.toDate());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  snapshot["text"],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey
                ),
              ),
              Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          snapshot["from"],
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        duration.inDays>5? "${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}" :
                        duration.inDays>=1?"${duration.inDays} ${duration.inDays<=1?"day":"days"} ago":
                        duration.inHours>=1?"${duration.inHours}  ${duration.inHours<=1?"hour":"hours"} ago":
                        duration.inMinutes>=1?"${duration.inMinutes} ${duration.inMinutes<=1?"minute":"minutes"} ago":
                        "${duration.inSeconds} ${duration.inSeconds<=1?"second":"seconds"} ago",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          FontAwesomeIcons.share,
                          size: 15,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                            Icons.more_vert,
                          size: 15,
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
