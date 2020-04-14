import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peddazz/notes/note_model.dart';

List<Color> colorList= [
  Colors.blueGrey,
  Colors.deepPurpleAccent,
  Colors.deepPurple,
  Colors.blue
];

class NoteCard extends StatelessWidget {

  const NoteCard({
    this.noteData,
    this.onTapAction,
    Key key
}) : super(key: key);

  final NotesModel noteData;
  final Function(NotesModel noteData) onTapAction;

  @override
  Widget build(BuildContext context) {
    String neatDate = DateFormat.yMd().add_jm().format(noteData.date);
    Color color = colorList.elementAt(noteData.title.length % colorList.length);
    return Container(
      margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [buildBoxShadow(color, context)]
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).dialogBackgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            onTapAction(noteData);
          },
          splashColor: color.withAlpha(20),
          highlightColor: color.withAlpha(10),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    '${noteData.title.trim().length <= 20 ? noteData.title.trim() : noteData.title.trim().substring(0, 20) + '...'}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                      '${noteData.content.trim().split('\n').first.length <= 30 ? noteData.content.trim().split('\n').first : noteData.content.trim().split('\n').first.substring(0, 30) + '...'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 14),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$neatDate',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade300,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxShadow buildBoxShadow(Color color, BuildContext context)
  {
    return BoxShadow(
      color: color.withAlpha(25),
      blurRadius: 8,
      offset: Offset(0, 8)
    );
  }
}
