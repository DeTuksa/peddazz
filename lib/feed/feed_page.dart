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

  Widget thought = Column(
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
            child: Text("This is the first tweet on this forum. I'm still contemplating on the name to give this platform. Any ideas?"),
          ),
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.reply),
                onPressed: null
            ),
            
            IconButton(
                icon: Icon(Icons.repeat),
                onPressed: null
            ),
            
            IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: null
            ),
            
          ],
        ),

        Divider()
      ],
  );

  Column buildButtonColumn(Color color, IconData icon)
  {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: color,)
      ],
    );
  }


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

                  List<Widget> messages = docs.map((doc) => Tweet(
                    handle: doc.data['from'],
                    text: doc.data['text'],
                    timestamp: doc.data['timestamp'],
                    //person: MyApp.user.email == doc.data['from'],
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
          ],
        ),
      ),
    );
  }
}
