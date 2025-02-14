import 'package:comicverse/app_drawer.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Text("Hello from history!"),
      ),
      drawer: AppDrawer(),
    );
  }

}