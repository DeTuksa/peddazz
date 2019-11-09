import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
                icon: Icon(FontAwesomeIcons.igloo),
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
      onPressed: null,
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
