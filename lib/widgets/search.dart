import 'package:comicverse/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/komik.dart';
import '../provider/search_provider.dart';

class SearchKomikScreen extends StatefulWidget {
  const SearchKomikScreen({super.key});

  @override
  _SearchKomikScreenState createState() => _SearchKomikScreenState();
}

class _SearchKomikScreenState extends State<SearchKomikScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
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
              searchProvider.updateSearchText(_searchController.text);
              searchProvider.updateContentCollector(() => fetchKomikFromSearch(_searchController.text));
              Navigator.pop(context);
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
