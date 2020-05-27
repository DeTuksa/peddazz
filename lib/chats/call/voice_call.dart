import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:peddazz/chats/call/call.dart';
import 'package:peddazz/chats/call/call_method.dart';
import 'package:peddazz/chats/call/config.dart';
import 'package:peddazz/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peddazz/colors.dart';

class VoiceCallScreen extends StatefulWidget {

  final Call call;

  const VoiceCallScreen({Key key, this.call}) : super(key: key);

  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {

  final CallMethods callMethods = CallMethods();

  UserModel userModel;
  StreamSubscription callStreamSubscription;

  static final users = <int>[];
  final infoStrings = <String>[];
  bool muted = false;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    await initAgoraRtcEngine();
    addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.call.channelId, null, 0);
  }

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserModel>(context, listen: false);

      callStreamSubscription = callMethods.callStream(
          uid: '${Provider.of<UserModel>(context, listen: false).userData.userId}'
      ).listen((DocumentSnapshot ds) {
        switch(ds.data) {
          case null:
            Navigator.pop(context);
            break;

          default:
            break;
        }
      });
    });
  }

  Future<void> initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableAudio();
    await AgoraRtcEngine.enableInEarMonitoring(true);
    await AgoraRtcEngine.setInEarMonitoringVolume(40);
    await AgoraRtcEngine.setEnableSpeakerphone(false);
    await AgoraRtcEngine.setDefaultAudioRouteToSpeaker(false);
  }

  void addAgoraEventHandlers() async {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        infoStrings.add(info);
        AgoraRtcEngine.enableAudio();
        AgoraRtcEngine.disableVideo();
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
        String channel,
        int uid,
        int elapsed
        ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        infoStrings.add(info);
        AgoraRtcEngine.enableAudio();
        AgoraRtcEngine.disableVideo();
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        infoStrings.add('onLeaveChannel');
        users.clear();
        AgoraRtcEngine.enableAudio();
        AgoraRtcEngine.disableVideo();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        infoStrings.add(info);
        users.add(uid);
        AgoraRtcEngine.enableAudio();
        AgoraRtcEngine.disableVideo();
      });
    };

    AgoraRtcEngine.onUpdatedUserInfo = (AgoraUserInfo userInfo, int i) {
      setState(() {
        final info = 'onUpdatedUserInfo: ${userInfo.toString()}';
        infoStrings.add(info);
        AgoraRtcEngine.disableVideo();
      });
    };

    AgoraRtcEngine.onRejoinChannelSuccess = (String string, int a, int b) {
      setState(() {
        final info = 'onRejoinChannelSuccess: $string';
        infoStrings.add(info);
        AgoraRtcEngine.disableVideo();
      });
    };

    AgoraRtcEngine.onUserOffline = (int a, int b) {
      callMethods.endCall(call: widget.call);
      setState(() {
        final info = 'onUserOffline: a: ${a.toString()}, b: ${b.toString()}';
        infoStrings.add(info);
        AgoraRtcEngine.disableVideo();
      });
    };

    AgoraRtcEngine.onConnectionLost = () {
      setState(() {
        final info = 'onConnectionLost';
        infoStrings.add(info);
        AgoraRtcEngine.disableVideo();
      });
    };

    AgoraRtcEngine.onRegisteredLocalUser = (String s, int i) {
      setState(() {
        final info = 'onRegisteredLocalUser: string: s, i: ${i.toString()}';
        infoStrings.add(info);
        AgoraRtcEngine.disableVideo();
      });
    };


    AgoraRtcEngine.onFirstRemoteVideoFrame = (
        int uid,
        int width,
        int height,
        int elapsed,
        ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        infoStrings.add(info);
        AgoraRtcEngine.disableVideo();
      });
    };
  }

//  List<Widget> _getRenderViews() {
//    final List<AgoraRenderWidget> list = [
//      AgoraRenderWidget(0, local: true, preview: true),
//    ];
//    users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
//    return list;
//  }

//  Widget _videoView(view) {
//    return Expanded(child: Container(child: view));
//  }

//  Widget _expandedVideoRow(List<Widget> views) {
//    final wrappedViews = views.map<Widget>(_videoView).toList();
//    return Expanded(
//      child: Row(
//        children: wrappedViews,
//      ),
//    );
//  }

//  Widget _viewRows() {
//    final views = _getRenderViews();
//    switch (views.length) {
//      case 1:
//        return Container(
//            child: Column(
//              children: <Widget>[_videoView(views[0])],
//            ));
//      case 2:
//        return Container(
//            child: Column(
//              children: <Widget>[
//                _expandedVideoRow([views[0]]),
//                _expandedVideoRow([views[1]])
//              ],
//            ));
//      case 3:
//        return Container(
//            child: Column(
//              children: <Widget>[
//                _expandedVideoRow(views.sublist(0, 2)),
//                _expandedVideoRow(views.sublist(2, 3))
//              ],
//            ));
//      case 4:
//        return Container(
//            child: Column(
//              children: <Widget>[
//                _expandedVideoRow(views.sublist(0, 2)),
//                _expandedVideoRow(views.sublist(2, 4))
//              ],
//            ));
//      default:
//    }
//    return Container();
//  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: AppColor.light,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: AppColor.primary,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
        ],
      ),
    );
  }

  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) async {
    await callMethods.endCall(call: widget.call);
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  @override
  void dispose() {
    users.clear();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    callStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterRingtonePlayer.stop();
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.25
              ),
              height: MediaQuery.of(context).size.height *0.8,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'images/index.png',
                fit: BoxFit.contain,
              ),
            ),
            _panel(),
            _toolbar()
          ],
        ),
      ),
    );
  }
}