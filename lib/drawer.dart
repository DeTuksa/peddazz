import 'package:flutter/material.dart' as prefix0;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/main.dart';

Drawer globalDrawer(
    context
    ) {
  return Drawer(

    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
              color: AppColor.accent
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                    child: GestureDetector(
                      onTap: null,
                      child: Icon(Icons.photo_camera),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(MyApp.user.email, style: TextStyle(fontSize: 17, color: Colors.white),),
                  )
              )
            ],
          ),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.university),
          title: Text('Overview'),
          onTap: null,
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.clipboardList),
          title: Text('Planner'),
          onTap: null,
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.paperPlane),
          title: Text('Chats'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).popAndPushNamed("chats");
          },
        ),
        ListTile(
          leading: Icon(Icons.trending_up),
          title: Text('Feed'),
          onTap: ()
          {
            Navigator.pop(context);
            Navigator.of(context).popAndPushNamed("feed");
          },
        ),
        ListTile(
          leading: Icon(Icons.folder_shared),
          title: Text('My Files'),
          onTap: ()
          {
            Navigator.pop(context);
            Navigator.of(context).popAndPushNamed("files");
          },
        ),
        ListTile(
            leading: Icon(FontAwesomeIcons.book),
            title: Text('Notes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popAndPushNamed("notes");
            }
        ),
        ListTile(
            leading: Icon(Icons.mic),
            title: Text('Recordings'),
            onTap: ()
            {
              Navigator.pop(context);
              Navigator.of(context).popAndPushNamed("audio_recording");
            }
        ),
        Divider(
          height: 33,
        ),
        ListTile(
          title: Text('Settings'),
          trailing: Icon(Icons.settings),
          onTap: ()
          {
            Navigator.popAndPushNamed(context, "settings");
          },
        ),
        ListTile(
          title:Text('Sign Out'),
          trailing: Icon(Icons.power_settings_new, color: Colors.red),
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
    ),
  );
}