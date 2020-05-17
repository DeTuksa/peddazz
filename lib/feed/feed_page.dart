import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peddazz/chats/call/pickup_layout.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/feed/writeup_page.dart';
import 'package:peddazz/models/feed_model.dart';
import 'feed_tile.dart';
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


  TextEditingController message = TextEditingController();
  ScrollController scroll = ScrollController();
  TextEditingController searchController = TextEditingController();

//  int page = 1;
//
//  Key textKey;

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
    return PickupLayout(
      scaffold: Scaffold(

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
                          child: Consumer<FeedModel>(
                            builder: (context,feedModel,child) {
                              if(feedModel.feeds==null)return Center(

                              );
                              List<Widget> messages = feedModel.feeds.map((feed) => FeedTile(
                                feed: feed,
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
