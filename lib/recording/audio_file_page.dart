import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'save_recording.dart';
import 'playbar.dart';

class AudioFileList extends StatefulWidget {

  final FileSystemEntity file;
  AudioFileList({Key key, this.file}) : super(key: key);

  @override
  _AudioFileListState createState()
  {
    return new _AudioFileListState(file);
  }
}

class _AudioFileListState extends State<AudioFileList> {

  FileSystemEntity file;
  String filePath;
  String fileName;

  @override
  _AudioFileListState(FileSystemEntity file)
  {
    this.file = file;
    initFileAttributes();
  }

  initFileAttributes()
  {
    this.filePath = file.path;
    this.fileName = this.filePath.split("/").last.split('.').first;
    print("New " + fileName);
  }

  deleteFile(File file)
  {
    setState(() => file.deleteSync());
    print("Deleted file $fileName");
    Navigator.pop(context);
  }

  AlertDialog openDeleteDialog()
  {
    return AlertDialog(
      title: Text("Delete"),
      content: Text("$fileName ?"),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              deleteFile(this.file);
            },
            child: const Text("YES")
        ),

        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("NO")
        )
      ],
    );
  }

  saveDialogBuilder(BuildContext context)
  {
    SaveRecording save = SaveRecording(
      defaultAudio: file,
      dialog: "Rename $fileName",
      doLook: false,
    );
    return save;
  }

  saveDialog() async
  {
    File newFile = await showDialog(
        context: context,
      builder: (context) => saveDialogBuilder(context)
    );

    setState(() {
      file = newFile;
      initFileAttributes();
    });
  }

  Row createTrailing()
  {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          onSelected: (value) {},
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Rename',
              child: ListTile(
                leading: Icon(Icons.redo),
                title: Text('Rename'),
                onTap: () {
                  Navigator.pop(context);
                  saveDialog();
                  setState(() {});
                },
              ),
            ),

            PopupMenuDivider(),

            PopupMenuItem<String>(
              value: 'Delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete"),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                    builder: (_) => openDeleteDialog()
                  );
                  setState(() {});
                },
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if(!file.existsSync())
      {
        return Container(width: 0, height: 0,);
      }
    return new ListTile(
      title: new Text(fileName),
      dense: false,
      leading: Icon(Icons.play_circle_outline),
      contentPadding: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5
      ),
      trailing: createTrailing(),
      onTap: ()
      {
        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return AudioPlayBar(file: file);
            }
        );
      },
    );
  }
}


class FilePage extends StatefulWidget {

  FilePage({Key key}) : super(key: key);

  @override
  _FilePageState createState()
  {
    return _FilePageState();
  }
}

class _FilePageState extends State<FilePage> {

  _FilePageState();

  ListView fileListView(BuildContext context, AsyncSnapshot snapshot)
  {
    Directory directory = snapshot.data;

    List<FileSystemEntity> dirFiles = directory.listSync();

    List<FileSystemEntity> m4aFiles = dirFiles.where((file) => (file.path.endsWith('.m4a') && file.path.split('/').last != 'TempRecording.m4a')).toList();

    List<Widget> audioFileTiles = new List();

    for(FileSystemEntity file in m4aFiles)
      {
        if(file.path.endsWith('.m4a'))
          {
            audioFileTiles.add(new AudioFileList(file: file,));
          }
      }
    return ListView(
      children: audioFileTiles,
    );
  }

  @override
  Widget build(BuildContext context) {

    var futureBuilder = new FutureBuilder(
      future: getApplicationDocumentsDirectory(),
        builder: (BuildContext context, AsyncSnapshot snapshot)
        {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container();
            default:
              if(snapshot.hasError)
                return new Text("Errpr ${snapshot.error}");
              else
                return fileListView(context, snapshot);
          }
        }
    );

    return futureBuilder;
  }
}
