import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peddazz/chats/call/pickup_layout.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return PickupLayout(
      scaffold: Scaffold(
        body: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: height-40,
                  width: width,
                ),
                Container(
                  height: height*0.25,
                  width: width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.appBar, AppColor.dark
                      ]
                    ),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.elliptical(48, 18),
                      bottomLeft: Radius.elliptical(48, 18)
                    )
                  ),


                  child: Padding(
                    padding: EdgeInsets.only(
                      top: height*0.04,
                      left: width*0.05
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "Profile",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: height*0.18,
                  left: width*0.05,
                  right: width*0.05,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1.0,
                        )
                      ]
                    ),
                    height: 410,
                    width: width*0.9,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 60,
                      ),
                      child: Column(
                        children: <Widget>[

                          Text(
                            "${Provider.of<UserModel>(context,listen: false).userData.firstName} ${Provider.of<UserModel>(context,listen: false).userData.lastName}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              Provider.of<UserModel>(context,listen: false).userData.email,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey
                              ),
                            ),
                          ),

                          Divider(),

                          ListTile(
                            leading: Icon(
                              Icons.notifications,
                              color: AppColor.icon,
                            ),
                            title: Text(
                              "Notification",
                              style: TextStyle(
                                color: Colors.grey.shade600
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColor.icon,
                              size: 18,
                            ),
                          ),

                          ListTile(
                            leading: Icon(
                              Icons.help_outline,
                              color: AppColor.icon,
                            ),
                            title: Text(
                              "Help",
                              style: TextStyle(
                                  color: Colors.grey.shade600
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColor.icon,
                              size: 18,
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed("help");
                            },
                          ),

                          ListTile(
                            leading: Icon(
                              Icons.share,
                              color: AppColor.icon,
                            ),
                            title: Text(
                              "Share with a friend",
                              style: TextStyle(
                                  color: Colors.grey.shade600
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColor.icon,
                              size: 18,
                            ),
                            onTap: () {
                              final RenderBox box = context.findRenderObject();
                              Share.share("Check out Peddazz, I use it to check trends at my school,"
                                  " plan school activities, message and call people. Get it for free"
                                  " at https://peddazz.com",
                                  sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                            },
                          ),

                          ListTile(
                            leading: Icon(
                              Icons.feedback,
                              color: AppColor.icon,
                            ),
                            title: Text(
                              "Review",
                              style: TextStyle(
                                  color: Colors.grey.shade600
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColor.icon,
                              size: 18,
                            ),
                          ),

                          ListTile(
                            leading: Icon(
                              Icons.info_outline,
                              color: AppColor.icon,
                            ),
                            title: Text(
                              "About",
                              style: TextStyle(
                                  color: Colors.grey.shade600
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColor.icon,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: height*0.085,
                  left: width*0.3,
                  right: width*0.3,
                  child: Container(
                    height: 120,
                    width: 120,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(72),
                        child: Image.asset("images/index.png"),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: height*0.865,
                  child: Container(
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width*0.05,
                        right: width*0.05,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FlatButton(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6.0))
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10
                            ),
                            color: AppColor.dark,
                          ),

                          FlatButton(
                            onPressed: () {
                              logOutDialog();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6.0))
                            ),
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            color: Colors.red.shade400,
                            padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: width*0.2
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> logOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          title: Text('Sign Out?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to sign out?')
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('YES'),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value){
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
            )
          ],
        );
      }
    );
  }
}
