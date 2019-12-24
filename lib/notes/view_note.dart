import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:intl/intl.dart';
import 'edit_note.dart';
import 'database.dart';
import 'note_model.dart';

class ViewNotePage extends StatefulWidget {

  Function() triggerRefresh;
  NotesModel currentNote;

  ViewNotePage({Key key, Function() triggerRefresh, NotesModel currentNote}) : super(key: key) {
    this.triggerRefresh = triggerRefresh;
    this.currentNote = currentNote;
  }

  @override
  _ViewNotePageState createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                height: 40,
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 40, bottom: 16
                ),
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  child: Text(
                    widget.currentNote.title,
                    style: prefix0.TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ),

              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    DateFormat.yMd().add_jm().format(widget.currentNote.date),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 24, top: 36, right: 24, bottom: 24
                ),
                child: Text(
                  widget.currentNote.content,
                  style: prefix0.TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18
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

                      IconButton(
                          onPressed: edit,
                          icon: Icon(Icons.mode_edit)
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
    await NotesDatabaseService.db.updateNoteInDB(widget.currentNote);
    widget.triggerRefresh();
  }

  void delete() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),

          title: Text(
            'Delete note'
          ),

          content: Text('This note will be deleted permanently'),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  await NotesDatabaseService.db.deleteNoteInDB(widget.currentNote);
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

  void edit() async {
    Navigator.pop(context);
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => EditNote(
            existingNote: widget.currentNote,
            triggerRefresh: widget.triggerRefresh,
          )
        )
    );
  }
}
