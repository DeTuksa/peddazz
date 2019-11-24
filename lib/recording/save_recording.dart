import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:path/path.dart' as q;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SaveRecording extends StatefulWidget {

  final File defaultAudio;
  final String dialog;
  final bool doLook;
  String newPath;
  SaveRecording({
    Key key,
    this.defaultAudio,
    this.dialog = "Save file?",
    this.doLook = true,
}) : super(key: key);

  @override
  _SaveRecordingState createState() {
    _SaveRecordingState saveRecord = _SaveRecordingState(defaultAudio, dialog, doLook);
    newPath = saveRecord.newPath;
    return saveRecord;
  }
}

class _SaveRecordingState extends State<SaveRecording> {
  File defaultAudio;
  String dialog;
  String newPath;
  TextEditingController textController;
  bool doLook;

  _SaveRecordingState(this.defaultAudio, this.dialog, this.doLook);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTextController(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.textController.dispose();
  }

  initTextController(bool doRebuildTextController)
  {
    if (doLook)
      {
        initTextControllerWithLargestName(
          doRebuildTextController: doRebuildTextController
        );
      } else {
      initTextControllerWithCurrentName(
        doRebuildTextController: doRebuildTextController
      );
    }
  }

  Future<Null> initTextControllerWithCurrentName({bool doRebuildTextController = true}) async
  {
    setState(() {
      this.newPath = defaultAudio.path;
      String defaultFileName = defaultAudio.path.split('/').last.split('.').first;
      if(doRebuildTextController)
        {
          this.textController = TextEditingController(text: defaultFileName);
        }
    });
  }

  Future<Null> initTextControllerWithLargestName({bool doRebuildTextController = true}) async
  {
    Directory directory = await getApplicationDocumentsDirectory();
    String fileName = await largestNumberedFileName();
    print("new $fileName");
    String filePath = q.join(directory.path, fileName + '.m4a');
    setState(() {
      this.newPath = filePath;
      if(doRebuildTextController)
        {
          this.textController = TextEditingController(text: fileName);
        }
    });

    //String fileName = await la
}

Future<String> largestNumberedFileName(
  {String fileNamePrefix: "Recording-", String delimiter: "-"}
    ) async {
    bool isNumeric(String num) {
      if (num == null)
        {
          return false;
        }

      return double.parse(num, (e) => null) != null ||
      int.parse(num, onError: (e) => null) != null;
    }

    try {
      Directory directory = await getApplicationDocumentsDirectory();
      int largestNum = 0;
      print("Dir $directory");
      List<FileSystemEntity> entities = directory.listSync();
      for(FileSystemEntity entity in entities)
        {
          String filePath = entity.path;
          if(filePath.endsWith('m4a') && !(filePath.startsWith('Temp')))
            {
              String bname = q.basename(filePath);
              if(bname.startsWith(fileNamePrefix))
                {
                  final String noExt = bname.split('.')[0];
                  String strIndex = noExt.split(delimiter).last;
                  if(isNumeric((strIndex)))
                    {
                      int curInt = int.parse(strIndex);
                      largestNum = max(largestNum, curInt);
                    }
                }
            }
        }

      largestNum += 1;
      print("Found largest index $largestNum");
      return fileNamePrefix + largestNum.toString();
    } catch (e)
  {
    print("Error! Failed to get documents directory and calculate largest numbered filename");
    return "Tuksa!!!!!";
  }
}

void renameAudio() async
{
  newPath = q.join(q.dirname(defaultAudio.path), textController.text + '.m4a');
  if(defaultAudio != null && newPath != null)
    {
      try {
        print("New file path $newPath");
        defaultAudio.rename(newPath);
      } catch (e) {
        if(await defaultAudio.exists()) {
          print("File $defaultAudio already exists.");
        } else {
          print("Error renaming file.");
        }
      }
    } else {
    print("File $defaultAudio is null!");
  }

  Navigator.pop(context, File(newPath));
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(dialog),
      content: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          labelText: "File name",
          hintText: "Enter a file name without extension"
        ),
        validator: (value) {
          if (value.isEmpty)
            return "please enter a file name";
        },
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => renameAudio(),
            child: const Text("SAVE")
        ),

        new FlatButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("CANCEL")
        )
      ],
    );
  }
}
