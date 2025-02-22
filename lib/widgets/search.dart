import 'package:comicverse/app_router.dart';
import 'package:flutter/material.dart';

class SelectTagsScreen extends StatefulWidget {
  @override
  _SelectTagsScreenState createState() => _SelectTagsScreenState();
}

class _SelectTagsScreenState extends State<SelectTagsScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(166, 255, 255, 255),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close),
        ),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              print("Pencarian: ${_searchController.text}");
              Navigator.of(context).toHomeScreen(search: _searchController.text);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Spacer(),
        ],
      ),
    );
  }
}
