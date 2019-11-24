import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

enum PlayerState {stopped, playing, paused}

class AudioPlayBar extends StatefulWidget {

  final FileSystemEntity file;
  AudioPlayBar({Key key, this.file}) : super(key: key);

  @override
  AudioPlayBarState createState() {
    return new AudioPlayBarState(file);
  }
}

class AudioPlayBarState extends State<AudioPlayBar> {

  File file;
  AudioPlayer audioPlayer;
  Duration duration;
  Duration position;

  PlayerState playerState = PlayerState.stopped;
  StreamSubscription positionSub;
  StreamSubscription audioPlayerStateSub;
  StreamSubscription audioPlayerCompleteSub;
  StreamSubscription audioPlayerDurationSUb;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText => duration != null ? duration.toString().split('.').first : '';
  get positionText => position != null ? position.toString().split('.').first : '';

  @override
  AudioPlayBarState(this.file);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    positionSub.cancel();
    audioPlayerStateSub.cancel();
    audioPlayerCompleteSub.cancel();
    audioPlayerDurationSUb.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer()
  {
    audioPlayer = new AudioPlayer();

    positionSub = audioPlayer.onAudioPositionChanged.listen((p) => setState(() => position = p));

    audioPlayerStateSub = audioPlayer.onPlayerStateChanged.listen((s) {
      if(s == AudioPlayerState.PLAYING)
        {
          setState(() {
            playerState = PlayerState.playing;
          });
        } else if(s == AudioPlayerState.STOPPED)
          {
            setState(() {
              playerState = PlayerState.stopped;
            });
          }
    }, onError: (msg) {
      setState(() {
        print("Error in subscription to audioPlayerState");
        print(msg);
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    }
    );

    audioPlayerCompleteSub = audioPlayer.onPlayerCompletion.listen((c) => setState(() => playerState = PlayerState.stopped));

    audioPlayerDurationSUb = audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });
    audioPlayer.state = AudioPlayerState.STOPPED;
  }

  Future play() async
  {
    final playPosition = (position != null && duration != null &&
        position.inMilliseconds > 0 && position.inMilliseconds
        < duration.inMilliseconds) ? position : null;
    final result = await audioPlayer.play(file.path, isLocal: true, position: playPosition);
    if(result == 1)
      setState(() => playerState = PlayerState.playing);
  }

  Future pause() async
  {
    print("paused");
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async
  {
    print("stopped");
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
    });
  }

  Future fastForward() async
  {
    try {
      Duration newDuration = duration *.8;
      audioPlayer.seek(newDuration);
      setState(() {
        playerState = PlayerState.playing;
      });
    } catch (e) {
      print("Error attempting to fast forward");
      print(e);
    }
  }

  Future fastRewind() async {

    try{
      Duration newDuration = duration*.2;
      audioPlayer.seek(newDuration);
      setState( (){
        playerState = PlayerState.playing;
      });
    }catch(e){
      print( "Error attempting to fast rewind");
      print(e);
    }
  }

  void moveSlider(double value)
  {
    if(value.toInt()%100 == 0)
      {
        setState(() {
          position = new Duration(milliseconds: value.toInt());
        });
      }
  }

  void finishedMovingSlider(double value)
  {
    value = max(0, value);
    audioPlayer.pause();
    position = new Duration(milliseconds: value.toInt());
    try {
      audioPlayer.seek(position);
    } catch(e)
    {
      print("Error attempting to seek to new position");
      print(e);
    }

    setState(() {
      playerState = PlayerState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Column(
              children: [
                Spacer(flex:1),
                // Display the filename
                Text(
                  file.path.split('/').last.split('.').first,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1.5,
                ),
                Container(height:12.0),
                // Display the audio position (time)
                position == null ?
                Text("0:00:00/0:00:00") : Text("$positionText / $durationText",textScaleFactor: 1.2,),
                // Display the slider
                duration == null
                    ? Container() :
                Slider(
                  value: position?.inMilliseconds?.toDouble() ?? 0.01 ,
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble(),
                  divisions: 40,
                  onChanged: moveSlider,
                  onChangeEnd: finishedMovingSlider,
                ),
                Container(height:20.0),
                // Display the audio control buttons
                ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //new FloatingActionButton(
                      //  child: new Icon(Icons.fast_rewind),
                      //  onPressed: ()=>fastRewind(),
                      //  mini: true,
                      //),
                      new FloatingActionButton(
                        child: isPlaying
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow),
                        onPressed: isPlaying ? () => pause() : () => play(),
                      ),
                      //new FloatingActionButton(
                      //  child: new Icon(Icons.fast_forward),
                      // mini: true,
                      //  onPressed: () => fastForward(),
                      //),
                    ]),
                Spacer(),
              ],
            )
        )
    );
  }
}
