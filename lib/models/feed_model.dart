import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peddazz/models/user_model.dart';
import 'package:provider/provider.dart';

class FeedModel extends ChangeNotifier {
  List<Feed> feeds;
  StreamSubscription feedsSubscription;

  FeedModel() {
    feedsSubscription = Firestore.instance
        .collection('Feed')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((feedsSnap) {
      feeds = new List();
      feedsSnap.documents.forEach((doc) {
        feeds.add(Feed.fromJson(doc.data, doc.reference));
      });
      notifyListeners();
    });
    feedsSubscription.resume();
  }

  void likeFeed(Feed feed, BuildContext context) {
    if (feed.likes == null) {
      feed.likes = new List();
      feed.likes.add({"userId": Provider.of<UserModel>(context).user.uid});
      feed.reference.updateData({"likes": feed.likes});
    } else {
      //check if feed is already liked by user
      bool alreadyLiked = false;
      for (int x = 0; x < feed.likes.length; x++) {
        if (feed.likes[x]['userId'] ==
            Provider.of<UserModel>(context).user.uid) {
          alreadyLiked = true;
        }
      }
      if (alreadyLiked == false) {
        feed.likes.add({
          "userId": Provider.of<UserModel>(context, listen: false).user.uid
        });
        feed.reference.updateData({"likes": feed.likes});
      }
    }
  }

  void unlikeFeed(Feed feed, BuildContext context) {
    if (feed.likes != null) {
      int toDeleteIndex;
      for (int x = 0; x < feed.likes.length; x++) {
        if (feed.likes[x]['userId'] ==
            Provider.of<UserModel>(context, listen: false).user.uid) {
          toDeleteIndex = x;
        }
      }
      if (feed.likes.length > 0) {
        feed.likes.removeAt(toDeleteIndex);
        feed.reference.updateData({"likes": feed.likes});
      }
    }
  }

  Future<bool> postFeed(String text,BuildContext context) async{
    try{
      if(text.length > 0) {
        await Firestore.instance.collection('Feed').add({
          'text': text,
          'from': Provider.of<UserModel>(context,listen: false).userData.firstName+" "+Provider.of<UserModel>(context,listen: false).userData.lastName,
          'timestamp': Timestamp.now(),
          'likes': [],
        });
        return true;
      }{
        return false;
      }
    }catch(err){
      return false;
    }
  }
}

class Feed {
  String from;
  List likes;
  String text;
  Timestamp timestamp;
  DocumentReference reference;

  Feed({this.timestamp, this.text, this.from, this.likes, this.reference});
  factory Feed.fromJson(
      Map<String, dynamic> json, DocumentReference reference) {
    return Feed(
        from: json['from'],
        likes: new List.from(json['likes']),
        text: json['text'],
        timestamp: json['timestamp'],
        reference: reference);
  }
}
