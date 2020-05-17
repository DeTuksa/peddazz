import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peddazz/chats/call/call.dart';
import 'package:peddazz/chats/call/video_call.dart';

class PickUpScreen extends StatefulWidget {

  final Call call;

  PickUpScreen({
    @required this.call
});

  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  final CallMethods callMethods = CallMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30,),
            Text(
              'Incoming...',
              style: TextStyle(
                fontSize: 30
              ),
            ),
            SizedBox(height: 75,),
            Container(
              height: 150,
              width: 150,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(160),
                  child: Image.asset("images/index.png"),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            SizedBox(height: 125,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.call_end,
                    size: 32,
                  ),
                  color: Colors.redAccent,
                  onPressed: () async {
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.call,
                    size: 32,
                  ),
                  color: Colors.green,
                  onPressed: () async => widget.call.isCall == 'video'
                  ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoCallScreen(call: widget.call,)
                    )
                  ) : {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
