import 'package:flutter/material.dart';
import 'package:peddazz/colors.dart';
import 'package:provider/provider.dart';
import 'package:peddazz/models/feed_model.dart';

class PenThoughts extends StatefulWidget {
  @override
  _PenThoughtsState createState() => _PenThoughtsState();
}

class _PenThoughtsState extends State<PenThoughts> {
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(

      child: Scaffold(

        appBar: AppBar(

          backgroundColor: Colors.white,

          leading: Row(

            children: <Widget>[

              IconButton(

                  icon: Icon(Icons.close, color: AppColor.icon,),
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
              )
            ],
          ),
          actions: <Widget>[

            FlatButton(
                onPressed: ()
                {
                  Provider.of<FeedModel>(context,listen: false).postFeed(message.text, context).then((value){
                    message.clear();
                  });
                  Navigator.pop(context);
                },

                child: Text(
                  'Send',
                  style: TextStyle(
                      color: AppColor.icon
                  ),
              )
            )
          ],
        ),

        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              cursorColor: AppColor.icon,
              keyboardType: TextInputType.multiline,
              maxLength: 140,
              maxLines: null,
              controller: message,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.icon
                  )
                ),
                labelText: 'Put your thoughts out there...',
                labelStyle: TextStyle(
                  color: AppColor.icon
                ),
                border: OutlineInputBorder()
              ),
            ),
          ),
        ),
      ),
    );
  }
}