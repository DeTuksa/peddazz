import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peddazz/colors.dart';
import 'package:peddazz/notes/database.dart';
import 'package:peddazz/notes/edit_note.dart';
import 'package:peddazz/notes/note_model.dart';
import 'package:peddazz/notes/note_outline.dart';
import 'package:peddazz/notes/view_note.dart';

class NotesScreen extends StatefulWidget {

  NotesScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {

  List<NotesModel> notesList = [];
  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    setNotesFromDB();
  }

  setNotesFromDB() async {
    print('Entered setNotes');
    var fetchedNotes = await NotesDatabaseService.db.getNotesFromDB();
    setState(() {
      notesList = fetchedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          gotoEditNote();
        },
        child: Icon(Icons.add),
        backgroundColor: AppColor.dark,
      ),
      
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      
                      Text('Notes', style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height*0.035
                      ),)
                    ],
                  ),
                  IconButton(icon: Icon(Icons.search), onPressed: null),

//                  Container(
//                    height: MediaQuery.of(context).size.height*0.04,
//                    width: MediaQuery.of(context).size.height*0.3,
//                    child: TextFormField(
//                      decoration: InputDecoration(
//                        suffixIcon: GestureDetector(
//                            child: Icon(Icons.search),
//                          onTap: null,
//                        )
//                      ),
//                    ),
//                  )
                ],
              ),

              Container(
                height: 40,
              ),
              notesList.isEmpty ? Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.35
                ),
                child: Container(
                  child: Center(
                    child: Text(
                      'Start writing...',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey.shade500
                      ),
                    ),
                  ),
                ),
              ) : Container(
                child: Column(
                  children: <Widget>[
                    ...buildNoteList()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildNoteList() {
    List<Widget> noteComponentsList = [];
    notesList.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    notesList.forEach((note) {
      noteComponentsList.add(NoteCard(
        noteData: note,
        onTapAction: openNoteToRead,
      ));
    });
    return noteComponentsList;
  }

  void gotoEditNote() {
    Navigator.push(context, CupertinoPageRoute(
      builder: (context) => EditNote(triggerRefresh: refetchNotesFromDB)
    ));
  }

  void refetchNotesFromDB() async {
    await setNotesFromDB();
    print('Notes refetched');
  }

  openNoteToRead(NotesModel noteData) async {
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(context, FadeRoute(
      page: ViewNotePage(
        triggerRefresh: refetchNotesFromDB,
        currentNote: noteData,
      )
    ));
    await Future.delayed(Duration(milliseconds: 300), () {});
  }
}


class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}