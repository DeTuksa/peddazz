import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:path/path.dart' as q;
import 'package:path_provider/path_provider.dart';
import 'package:peddazz/recording/audio_file_page.dart';
import 'dart:io';
import 'save_recording.dart';

 final globalKey = GlobalKey<ScaffoldState>();
class AudioRecording extends StatefulWidget {

  AudioRecording({Key key}) : super(key: key);

  @override
  _AudioRecordingState createState() => _AudioRecordingState();
}

class _AudioRecordingState extends State<AudioRecording> {


  Recording recording;
  bool _isRecording = false;
  bool save = false;

  String file = "Record";
  File defaultFile;

  startRecording() async
  {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String newFilePath = q.join(directory.path, this.file);
      File audioFile = File(newFilePath+'.m4a');
      globalKey.currentState
      .showSnackBar(new SnackBar(content: new Text("Recording"),
      duration: Duration(milliseconds: 1400),));

      if(await audioFile.exists())
        {
          await audioFile.delete();
        }

      if(await AudioRecorder.hasPermissions)
        {
          await AudioRecorder.start(
            path: newFilePath, audioOutputFormat: AudioOutputFormat.WAV
          );
        } else {
        globalKey.currentState.showSnackBar(new SnackBar(content: new Text("Error! Audio recorder lacks permissions")));
      }

      bool isRecording = await AudioRecorder.isRecording;
      setState(() {
        _isRecording = isRecording;
        defaultFile = audioFile;
      });
    }
    catch(e)
    {
      print(e);
    }
  }

  stopRecording() async
  {
    await AudioRecorder.stop();
    bool isRecording = await AudioRecorder.isRecording;

    Directory directory = await getApplicationDocumentsDirectory();

    setState(() {
      _isRecording = isRecording;
      save = true;
      defaultFile = File(q.join(directory.path, this.file+'.wav'));
    });
    saveDialog();
  }

  deleteCurrentFile() async
  {
    if (defaultFile != null)
      {
        setState(() {
          _isRecording = false;
          save = false;
          defaultFile.delete();
        });
      }
    else {
      print('Error! Default audio file is $defaultFile');
    }
    Navigator.pop(context);
  }

  AlertDialog deleteFileDialog()
  {
    return AlertDialog(
      title: Text("Delete current recording?"),
      actions: <Widget>[
        new FlatButton(
          child: const Text("YES"),
          onPressed: () => deleteCurrentFile(),
        ),

        new FlatButton(
          child: const Text("NO"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  saveDialog() async
  {
    File newFile = await showDialog(
        context: context,
      builder: (context) => SaveRecording(defaultAudio: defaultFile,)
    );

    if(newFile != null)
      {
        String baseName = q.basename(newFile.path);
        globalKey.currentState.showSnackBar(
          new SnackBar(content: new Text("Saved file $baseName"),
          duration: Duration(milliseconds: 1400),)
        );

        setState(() {
          _isRecording = false;
          save = false;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AudioRecorder.isRecording,
      builder: audioCard,
    );
  }

  Widget audioCard (BuildContext context, AsyncSnapshot snapshot)
  {
    switch (snapshot.connectionState)
    {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return Container();
      default:
        if(snapshot.hasError)
          {
            return new Text('Error: ${snapshot.error}');
          } else {

          bool isRecording = snapshot.data;
          _isRecording = isRecording;

          return new Scaffold(
            key: globalKey,
            appBar: AppBar(
              title: Text(
                "Recording",
              ),
            ),
//            body: Builder(
//              builder: (BuildContext context) {
//                return new Card(
//                  child: new Center(
//                    child: new Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        Spacer(flex: 1,),
//
//                        Padding(
//                            padding: EdgeInsets.only(
//                                top: MediaQuery.of(context).size.height*0.05
//                            )
//                        ),
//
//                        Container(
//                          width: MediaQuery.of(context).size.height*0.15,
//                          height: MediaQuery.of(context).size.height*0.15,
//                          child: CircularProgressIndicator(
//                            strokeWidth: 15,
//                            valueColor: _isRecording ? AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent) : AlwaysStoppedAnimation<Color>(Colors.blueGrey[50]),
//                            value: _isRecording ? null : 100,
//                          ),
//                        ),
//
//                        Spacer(),
//
//                        Padding(
//                          padding: EdgeInsets.only(
//                              top: MediaQuery.of(context).size.height*0.05
//                          ),
//                        ),
//
//                        Row(
//                          mainAxisSize: MainAxisSize.max,
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          children: <Widget>[
//                            Column(
//                              children: <Widget>[
//                                new FloatingActionButton(
//                                  child: save ? new Icon(Icons.cancel) : null,
//                                  disabledElevation: 0.0,
//                                  backgroundColor: save ? Colors.deepPurpleAccent : Colors.transparent,
//                                  onPressed: save ? (() => showDialog(
//                                      context: context,
//                                      builder: (context) => deleteFileDialog()
//                                  )) : null,
//                                  mini: true,
//                                  heroTag: null,
//                                ),
//
//                                Padding(
//                                  padding: EdgeInsets.only(
//                                    top: 8,
//                                  ),
//                                  child: save ? new Text(
//                                    'Delete',
//                                    textScaleFactor: 1.2,
//                                  ) : Container(),
//                                )
//                              ],
//                            ),
//
////                            Column(
////                              children: <Widget>[
////                                new FloatingActionButton(
////                                  child: _isRecording ? new Icon(Icons.stop, size: MediaQuery.of(context).size.height*0.04,) : new Icon(Icons.mic,  size: MediaQuery.of(context).size.height*0.05,),
////                                  onPressed: _isRecording ? stopRecording : startRecording,
////                                  heroTag: null,
////                                  disabledElevation: 0.0,
////                                ),
////
////                                Padding(
////                                  padding: EdgeInsets.only(
////                                    top: 8,
////                                  ),
////                                  child: _isRecording ? new Text(
////                                    'Stop',
////                                    textScaleFactor: 1.5,
////                                  ) : new Text(
////                                    'Record',
////                                    textScaleFactor: 1.5,
////                                  ),
////                                )
////                              ],
////                            ),
////
////                            Column(
////                              children: <Widget>[
////                                new FloatingActionButton(
////                                  child: save ? new Icon(Icons.check_circle) : null,
////                                  backgroundColor: save ? Colors.deepPurpleAccent : Colors.transparent,
////                                  onPressed: save ? saveDialog : null,
////                                  mini: true,
////                                  heroTag: null,
////                                  disabledElevation: 0.0,
////                                ),
////
////                                Padding(
////                                  padding: EdgeInsets.only(
////                                    top: 8,
////                                  ),
////                                  child: save ? new Text(
////                                    'Save',
////                                    textScaleFactor: 1.2,
////                                  ) : Container(),
////                                )
////                              ],
////                            )
//                          ],
//                        ),
//
//                        Spacer()
//                      ],
//                    ),
//                  ),
//                );
//              }
//            ),
          body: FilePage(),
            floatingActionButton: FloatingActionButton(
                onPressed: _isRecording ? stopRecording : startRecording,
              child: _isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
            ),
          );
        }
    }
  }
}
