import 'package:flutter/material.dart';
import 'package:peddazz/drawer.dart';
import 'package:peddazz/recording/audio_file_page.dart';

class Storage extends StatefulWidget {
  @override
  _StorageState createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Files"),
      ),
      drawer: globalDrawer(context),
      body: SafeArea(
        top: false,
          bottom: false,
          child: FilePage()
      ),
    );
  }
}
