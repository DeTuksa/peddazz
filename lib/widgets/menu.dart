import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget menu(context, slideAnimation, menuAnimation) {
  return SlideTransition(
    position: slideAnimation,
    child: ScaleTransition(
      scale: menuAnimation,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(FontAwesomeIcons.school),
                title: Text("Overview"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.clipboard),
                title: Text("Planner"),
                onTap: () {
                  Navigator.of(context).popAndPushNamed("planner");
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.paperPlane),
                title: Text("Chats"),
                onTap: () {
                  Navigator.of(context).popAndPushNamed("chats");
                },
              ),
              ListTile(
                leading: Icon(Icons.trending_up),
                title: Text("Feed"),
                onTap: () {
                  Navigator.of(context).popAndPushNamed("feed");
                },
              ),
              ListTile(
                leading: Icon(Icons.folder_shared),
                title: Text("My Files"),
                onTap: () {
                  Navigator.of(context).popAndPushNamed("files");
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.book),
                title: Text("Notes"),
                onTap: () {
                  Navigator.of(context).popAndPushNamed("notes");
                },
              ),
              ListTile(
                leading: Icon(Icons.mic),
                title: Text("Recordings"),
                onTap: () {
                  Navigator.of(context).popAndPushNamed("audio_recording");
                },
              )
            ],
          ),
        ),
      ),
    ),
  );
}
