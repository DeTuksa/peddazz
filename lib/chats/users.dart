import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peddazz/main.dart';

class UsersDisplay extends StatefulWidget {
  @override
  State createState() => UsersDisplayState();
}

class UsersDisplayState extends State<UsersDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("user").snapshots(),
        builder: (context, usersSnapshot) {
          if (usersSnapshot.hasData) {
            return ListView.builder(
              itemCount: usersSnapshot.data.documents.length,
              itemBuilder: (context, count) {
                String email = usersSnapshot.data.documents[count]["email"]
                        .toString()
                        .trim();
                if (email == MyApp.user.email) {
                  return Container();
                }
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, "chatPage",
                        arguments: usersSnapshot.data.documents[count]
                            ["userID"]);
                  },
                  title: Text(
                      "${usersSnapshot.data.documents[count]["firstName"]} ${usersSnapshot.data.documents[count]["lastName"]}"),
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
    );
  }
}
