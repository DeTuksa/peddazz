import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peddazz/models/user_model.dart';
import 'package:peddazz/models/feed_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peddazz/colors.dart';
import 'package:flutter/cupertino.dart';

class FeedTile extends StatefulWidget{
  final Feed feed;
  FeedTile({this.feed}):super(key: new GlobalKey());

  @override
  _FeedTileState createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {

  bool isLiked = false;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context){
    Timestamp timestamp = widget.feed.timestamp;
    List _likes = new List.from(widget.feed.likes);
    if(firstBuild==true){
      _likes.forEach((element) {
        if(element['userId']==Provider.of<UserModel>(context,listen: false).user.uid){
          isLiked=true;
        }
      });
      firstBuild=false;
    }
    Duration duration= Timestamp.now().toDate().difference(timestamp.toDate());

    return InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.all(Radius.circular(3)),
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                          child: ClipRRect(
                            child: Image.asset("images/index.png"),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.feed.from,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              SizedBox(height: 3,),
                              Text("SEET", style: TextStyle(
                                  color: AppColor.login2
                              ),)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 15
                    ),
                    child: Text(
                      widget.feed.text,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*0.02125,
                          color: Colors.black,
                          letterSpacing: 0.5
                      ),
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(12)),//FIXME
                            onTap: () {

                            },
                            child: Icon(
                              CupertinoIcons.conversation_bubble,
                              color: AppColor.icon,
                              size: 22,
                            ),
                          ),
                          SizedBox(height: 1,),
                          Text("1")
                        ],
                      ),

                      Column(
                        children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(12)),//FIXME
                            onTap: () async {
                              setState(() {
                                isLiked=!isLiked;
                              });
                              if(isLiked==false){
                                Provider.of<FeedModel>(context,listen: false).unlikeFeed(widget.feed, context);
                              }else{
                                Provider.of<FeedModel>(context,listen: false).likeFeed(widget.feed, context);
                              }
                              print(isLiked);
                            },
                            child: isLiked==false ? Icon(
                              Icons.star_border,
                              color: Colors.deepOrange,
                              size: 22,
                            ) : Icon(
                              Icons.star,
                              color: Colors.deepOrange,
                              size: 22,
                            ),
                          ),
                          SizedBox(height: 1,),
                          _likes == null ? Text("") : _likes.length == 0 ? Text("") : Text("${_likes.length}")
                        ],
                      ),

                      Text(
                          duration.inDays>5? "${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}" :
                          duration.inDays>=1?"${duration.inDays} ${duration.inDays<=1?"day":"days"} ago":
                          duration.inHours>=1?"${duration.inHours}  ${duration.inHours<=1?"hour":"hours"} ago":
                          duration.inMinutes>=1?"${duration.inMinutes} ${duration.inMinutes<=1?"minute":"minutes"} ago":
                          "${duration.inSeconds} ${duration.inSeconds<=1?"second":"seconds"} ago",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}