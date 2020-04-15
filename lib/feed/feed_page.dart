import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/feed/writeup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peddazz/models/user_model.dart';
import 'package:peddazz/widgets/menu.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {

  bool isCollapsed = true;
  final Duration duration = Duration(milliseconds: 300);
  AnimationController controller;
  Animation<double> scaleAnimation;
  Animation<double> menuAnimation;
  Animation<Offset> slideAnimation;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Firestore firestore = Firestore.instance;

  TextEditingController message = TextEditingController();
  ScrollController scroll = ScrollController();
  TextEditingController searchController = TextEditingController();

  int page = 1;

  Key textKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);
    scaleAnimation = Tween<double>(begin: 1, end: 1).animate(controller);
    menuAnimation = Tween<double>(begin: 0.5, end: 1).animate(controller);
    slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {
          setState(() {
            if(isCollapsed)
              controller.forward();
            else
              controller.reverse();

            isCollapsed = !isCollapsed;
          });
        }),
        actions: <Widget>[
          IconButton(
            onPressed: () {

            },
            tooltip: 'Search',
            icon: Icon(Icons.search),
            color: Colors.black,
          )
        ],
        elevation: 2,
        title: Text(
          'Feed',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  CupertinoIcons.news,
                  size: 22,
                ),
                onPressed: () {
                }
            ),
//            IconButton(
//                icon: Icon(
//                  CupertinoIcons.search,
//                  size: 22,
//                ),
//                onPressed: () {
//                }
//            ),
            IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  size: 22,
                ),
                onPressed: () {
                }
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.dark,
      child: Icon(
        CupertinoIcons.pen,
        size: 22,
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PenThoughts()));
      },
    ),

    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: Stack(
        children: <Widget>[
          menu(context, slideAnimation, menuAnimation),
          AnimatedPositioned(
            top: 0,
            bottom: 0,
            left: isCollapsed ? 0 : 0.6 * MediaQuery.of(context).size.width,
            right: isCollapsed ? 0 : -0.4 * MediaQuery.of(context).size.width,
            duration: duration,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Material(
                elevation: isCollapsed ? 0 : 4,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: firestore.collection('Feed').orderBy('timestamp', descending: true).snapshots(),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData)return Center(

                            );

                            List<DocumentSnapshot> docs = snapshot.data.documents;

                            List<Widget> messages = docs.map((doc) => Feed(
                              snapshot: doc,
                            ) ).toList();

                            return ListView(
                              controller: scroll,
                              children: messages,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchPage() {
    return SafeArea(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height*0.02,
              left: MediaQuery.of(context).size.height*0.02,
              right: MediaQuery.of(context).size.height*0.02,
              bottom: MediaQuery.of(context).size.height*0.02
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min

              ,
              children: <Widget>[
                Container(
                  height: 35,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset("images/index.png"),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height*0.02
                  ),
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)
                        ),
                        labelText: 'Search feed',

                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          Divider()
        ],
      ),
    );
  }
}


class Feed extends StatefulWidget{
  final DocumentSnapshot snapshot;
  Feed({this.snapshot});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  bool isLiked = false;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context){
    //widget.snapshot.reference.updateData({'${MyApp.user.displayName}': false});
    Timestamp timestamp = widget.snapshot["timestamp"];
    List _likes = new List.from(widget.snapshot["likes"]);
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
                                    widget.snapshot["from"],
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
                        widget.snapshot["text"],
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
                                  if(_likes!=null){
                                    int toDeleteIndex;
                                    for(int x=0;x<_likes.length;x++){
                                      if(_likes[x]["userId"]==Provider.of<UserModel>(context,listen: false).user.uid){
                                        toDeleteIndex=x;
                                      }
                                    }
                                    if(_likes.length>0) {
                                      _likes.removeAt(toDeleteIndex);
                                      widget.snapshot.reference.updateData({"likes":_likes});
                                    }
                                  }
                                }else{
                                  if(_likes==null){
                                    _likes=new List();
                                    _likes.add({"userId":Provider.of<UserModel>(context,listen: false).user.uid});
                                    widget.snapshot.reference.updateData({"likes":_likes});
                                  }else{
                                    _likes.add({"userId":Provider.of<UserModel>(context,listen: false).user.uid});
                                    widget.snapshot.reference.updateData({"likes":_likes});
                                  }
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
                            _likes == null ? Text("") : Text("${_likes.length}")
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
