import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/drawer.dart';
import 'package:peddazz/models/user_model.dart';
import 'package:provider/provider.dart';

class UsersDisplay extends StatefulWidget {
  @override
  State createState() => UsersDisplayState();
}

class UsersDisplayState extends State<UsersDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.dark,

      drawer: globalDrawer(context),


      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.06, left: 10, right: 10, bottom: MediaQuery.of(context).size.height*0.02
              ),
            child: Row(
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
                  "Messgaes",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white60
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                )
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("user").snapshots(),
                builder: (context, usersSnapshot) {
                  if (usersSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: usersSnapshot.data.documents.length,
                      itemBuilder: (context, count) {
                        String email = usersSnapshot.data.documents[count]["email"]
                            .toString()
                            .trim();
                        if (email == Provider.of<UserModel>(context).userData.email) {
                          return Container();
                        }
                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, "chatPage",
                                arguments: {"id": usersSnapshot.data.documents[count]["userID"],
                                  'firstname': usersSnapshot.data.documents[count]["firstName"],
                                  'lastname': usersSnapshot.data.documents[count]["lastName"]});
                          },
                          title: Text(
                              "${usersSnapshot.data.documents[count]["lastName"]} ${usersSnapshot.data.documents[count]["firstName"]}"),
                          subtitle:
                          Text("${usersSnapshot.data.documents[count]["email"]}"),
                        );
                      },
                    );
                  }

                  return Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),

//      body: StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance.collection("user").snapshots(),
//        builder: (context, usersSnapshot) {
//          if (usersSnapshot.hasData) {
//            return ListView.builder(
//              itemCount: usersSnapshot.data.documents.length,
//              itemBuilder: (context, count) {
//                String email = usersSnapshot.data.documents[count]["email"]
//                        .toString()
//                        .trim();
//                if (email == MyApp.user.email) {
//                  return Container();
//                }
//                return ListTile(
//                  onTap: () {
//                    Navigator.pushNamed(context, "chatPage",
//                        arguments: usersSnapshot.data.documents[count]
//                            ["userID"]);
//                  },
//                  title: Text(
//                      "${usersSnapshot.data.documents[count]["firstName"]} ${usersSnapshot.data.documents[count]["lastName"]}"),
//                  subtitle:
//                      Text("${usersSnapshot.data.documents[count]["email"]}"),
//                );
//              },
//            );
//          }
//
//          return Center(
//            child: SizedBox(
//              width: 25,
//              height: 25,
//              child: CircularProgressIndicator(
//                strokeWidth: 2,
//              ),
//            ),
//          );
//        },
//      ),
    );
  }
}
