import 'package:flutter/material.dart';
import 'package:peddazz/colors.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColor.dark,
        title: Text(
          'Help',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
        elevation: 3,
      ),

      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height*0.02
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.help_outline,
                color: AppColor.icon,
              ),
              title: Text(
                'FAQ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),

            ListTile(
              leading: Icon(
                Icons.people,
                color: AppColor.icon,
              ),
              title: Text(
                "Contact us",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400
                ),
              ),
              subtitle: Text(
                "Questions? Need help?"
              ),
            ),

            ListTile(
              leading: Icon(
                Icons.insert_drive_file,
                color: AppColor.icon,
              ),
              title: Text(
                "Terms and Privacy Policy",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

