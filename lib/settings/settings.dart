import 'package:flutter/material.dart';
import 'package:peddazz/main.dart';

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

          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height*0.02,
              left: MediaQuery.of(context).size.height*0.02,
              bottom: MediaQuery.of(context).size.height*0.02
            ),

            child: GestureDetector(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.notifications,
                    color: Colors.blueGrey,
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height*0.002,
                        left: MediaQuery.of(context).size.height*0.015
                      ),
                      child: Text(
                        "Notifications",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*0.02
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height*0.02,
              left: MediaQuery.of(context).size.height*0.02,
              bottom: MediaQuery.of(context).size.height*0.02
            ),

            child: GestureDetector(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.help_outline,
                    color: Colors.blueGrey,
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height*0.002,
                        left: MediaQuery.of(context).size.height*0.015
                      ),
                      child: Text(
                        "Help",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*0.02
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height*0.02,
              left: MediaQuery.of(context).size.height*0.02,
              bottom: MediaQuery.of(context).size.height*0.02
            ),

            child: GestureDetector(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.people,
                    color: Colors.blueGrey,
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height*0.002,
                        left: MediaQuery.of(context).size.height*0.015
                      ),
                      child: Text(
                        "Invite a friend",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*0.02
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height*0.02,
              left: MediaQuery.of(context).size.height*0.02
            ),

            child: GestureDetector(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.info_outline,
                    color: Colors.blueGrey,
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height*0.002,
                        left: MediaQuery.of(context).size.height*0.015
                      ),
                      child: Text(
                        "About Peddazz",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*0.02
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
