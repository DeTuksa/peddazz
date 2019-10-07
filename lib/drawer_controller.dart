import 'package:peddazz/home_drawer.dart';
import 'package:flutter/material.dart';

class DrawerController extends StatefulWidget
{
  final double drawerWidth;
  final Function(DrawerIndex) onDrawerCall;
  final Widget screenView;
  final Function(AnimationController) animeController;
  final Function(bool) isDrawn;
  final Widget menuView;
  final DrawerIndex screenIndex;
  final AnimatedIconData animatedIconData;

  const DrawerController({
    Key key,
    this.drawerWidth: 100,
    this.onDrawerCall,
    this.screenView,
    this.animeController,
    this.menuView,
    this.screenIndex,
    this.animatedIconData: AnimatedIcons.arrow_menu,
    this.isDrawn
  }) : super(key: key);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerController> with TickerProviderStateMixin
{
  ScrollController scrollController;
  AnimationController iconController;
  AnimationController animeController;
  double scrollOff = 0.0;
  bool drawerSet = false;

  @override
  void initState()
  {
    animeController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this
    );
    iconController = AnimationController(
      duration: Duration(milliseconds: 0),
      vsync: this
    );
    iconController.animateTo(
      1.0,
      duration: Duration(milliseconds: 0),
      curve: Curves.fastOutSlowIn
    );
    scrollController =
        ScrollController(initialScrollOffset: widget.drawerWidth);
    scrollController
      ..addListener(() {
        if (scrollController.offset <= 0) {
          if (scrollOff!= 1.0) {
            setState(() {
              scrollOff= 1.0;
              try {
                widget.isDrawn(true);
              } catch (e) {}
            });
          }
          iconController.animateTo(0.0,
              duration: Duration(milliseconds: 0), curve: Curves.linear);
        } else if (scrollController.offset > 0 &&
            scrollController.offset < widget.drawerWidth) {
          iconController.animateTo(
              (scrollController.offset * 100 / (widget.drawerWidth)) / 100,
              duration: Duration(milliseconds: 0),
              curve: Curves.linear);
        } else if (scrollController.offset <= widget.drawerWidth) {
          if (scrollOff != 0.0) {
            setState(() {
              scrollOff= 0.0;
              try {
                widget.isDrawn(false);
              } catch (e) {}
            });
          }
          iconController.animateTo(1.0,
              duration: Duration(milliseconds: 0), curve: Curves.linear);
        }
      });
    getInitState();
    super.initState();
  }

  Future<bool> getInitState() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      widget.animeController(iconController);
    } catch (e) {}
    await Future.delayed(const Duration(milliseconds: 100));
    scrollController.jumpTo(
      widget.drawerWidth,
    );
    setState(() {
      drawerSet = true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: PageScrollPhysics(parent: ClampingScrollPhysics()),
        child: Opacity(
          opacity: drawerSet ? 1 : 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width + widget.drawerWidth,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: widget.drawerWidth,
                  height: MediaQuery.of(context).size.height,
                  child: AnimatedBuilder(
                    animation: iconController,
                    builder: (BuildContext context, Widget child) {
                      return new Transform(
                        transform: new Matrix4.translationValues(scrollController.offset, 0, 0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: widget.drawerWidth,
                          child: HomeDrawer(
                            screenIndex: widget.screenIndex == null ? DrawerIndex.HOME : widget.screenIndex,
                            iconAnimationController: iconController,
                            callBackIndex: (DrawerIndex indexType) {
                              onDrawerClick();
                              try {
                                widget.onDrawerCall(indexType);
                              } catch (e) {}
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            blurRadius: 24),
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        IgnorePointer(
                          ignoring: scrollOff == 1 ? true : false,
                          child: widget.screenView == null
                              ? Container(
                                  color: Colors.white,
                                )
                              : widget.screenView,
                        ),
                        scrollOff == 1.0
                            ? InkWell(
                                onTap: () {
                                  onDrawerClick();
                                },
                              )
                            : SizedBox(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 8,
                              left: 8),
                          child: SizedBox(
                            width: AppBar().preferredSize.height - 8,
                            height: AppBar().preferredSize.height - 8,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: new BorderRadius.circular(
                                    AppBar().preferredSize.height),
                                child: Center(
                                  child: widget.menuView != null
                                      ? widget.menuView
                                      : AnimatedIcon(
                                          icon: widget.animatedIconData != null
                                              ? widget.animatedIconData
                                              : AnimatedIcons.arrow_menu,
                                          progress: iconController),
                                ),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  onDrawerClick();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void onDrawerClick() {
    if (scrollController.offset != 0.0) {
      scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController.animateTo(
        widget.drawerWidth,
        duration: Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}