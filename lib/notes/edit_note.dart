import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'database.dart';
import 'note_model.dart';

class EditNote extends StatefulWidget {

  Function() triggerRefresh;
  NotesModel existingNote;
  EditNote({Key  key, Function() triggerRefresh, NotesModel existingNote}) : super(key: key) {
    this.triggerRefresh = triggerRefresh;
    this.existingNote = existingNote;
  }

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

  bool isNoteNew = true;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();

  NotesModel currentNote;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.existingNote == null) {
      currentNote = NotesModel(
        content: '', title: '', date: DateTime.now()
      );
      isNoteNew = true;
    } else {
      currentNote = widget.existingNote;
      isNoteNew = false;
    }

    titleController.text = currentNote.title;
    contentController.text = currentNote.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(height: 80,),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  focusNode: titleFocus,
                  autofocus: true,
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSubmitted: (text) {
                    titleFocus.unfocus();
                    FocusScope.of(context).requestFocus(contentFocus);
                  },
                  onChanged: null, //FOR NOW
                  textInputAction: TextInputAction.next,
                  style: prefix0.TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter a title',
                    hintStyle: prefix0.TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 32,
                      fontWeight: FontWeight.w700
                    ),
                    border: InputBorder.none
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  focusNode: contentFocus,
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: null,
                  style: prefix0.TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter note...',
                    hintStyle: prefix0.TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
                    border: InputBorder.none
                  ),
                ),
              )
            ],
          ),

          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 80,
                color: Theme.of(context).canvasColor.withOpacity(0.3),
                child: SafeArea(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      Spacer(),

                      FlatButton(
                          onPressed: save,
                          child: Text('Save')
                      ),

                      IconButton(
                          icon: Icon(Icons.attach_file),
                          onPressed: null
                      ),

                      IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: () {
                            delete();
                          }
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void save() async {
    setState(() {
      currentNote.title = titleController.text;
      currentNote.content = contentController.text;
      print('${currentNote.content}');
    });

    if(isNoteNew) {
      var latestNote = await NotesDatabaseService.db.addNoteInDB(currentNote);
      setState(() {
        currentNote = latestNote;
      });
    } else {
      await NotesDatabaseService.db.updateNoteInDB(currentNote);
    }

    setState(() {
      isNoteNew = false;
    });

    widget.triggerRefresh();
    titleFocus.unfocus();
    contentFocus.unfocus();
  }

  void delete() async {
    if(isNoteNew) {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
        builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text('Delete note'),
              content: Text('This note will be deleted permanently'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () async {
                      await NotesDatabaseService.db.deleteNoteInDB(currentNote);
                      await NotesDatabaseService.db.init();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.of(context).popAndPushNamed("notes");
                    },
                    child: Text(
                      'DELETE',
                      style: prefix0.TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1
                      ),
                    )
                ),

                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'CANCEL',
                      style: prefix0.TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1
                      ),
                    )
                )
              ],
            );
        }
      );
    }
  }
}
