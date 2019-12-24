import 'package:flutter/material.dart';
//import 'package:peddazz/main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Settings"),
      ),

      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height*0.02,
              left: MediaQuery.of(context).size.height*0.02,
              bottom: MediaQuery.of(context).size.height*0.02
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.height*0.075,
                  height: MediaQuery.of(context).size.height*0.075,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    child: Image.asset("images/index.png"),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.025,
                    left: MediaQuery.of(context).size.height*0.015
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Username",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*0.02
                        ),
                        ),

                        Text(
                          "About individual",
                          style: TextStyle(
                            color: Colors.grey
                          )
                        )
                    ],
                  ),
                )
              ],
            )
          ),

          Divider(
            color: Colors.grey,
          ),

          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            onTap: null,
          ),

          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text("Help"),
            onTap: null,
          ),

          ListTile(
            leading: Icon(Icons.people),
            title: Text("Invite a friend"),
            onTap: null,
          ),

          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("About Peddazz"),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
