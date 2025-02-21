import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/komik_detail.dart';

class ViewChapter extends StatefulWidget {
  final String komikSlug;
  const ViewChapter({super.key, required this.komikSlug});

  @override
  State<StatefulWidget> createState() => _ViewChapterState();
}

class _ViewChapterState extends State<ViewChapter> {
  late ScrollController controller;
  List<String> items = List.empty(growable: true);
  List<List<String>> fullChapter = List.empty(growable: true);
  bool isFetchingChapters = true;
  int chapterContentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    fetchKomikChapter(widget.komikSlug).then((value) {
      final chunkItems = splitArray(value, 5);
      setState(() {
        fullChapter.addAll(chunkItems);
        items.addAll(chunkItems[chapterContentIndex]);
        isFetchingChapters = false;
      });
    });
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }


  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent && chapterContentIndex < fullChapter.length) {
      final newIdx = chapterContentIndex + 1;
      setState(() {
        items.addAll(fullChapter[newIdx]);
        chapterContentIndex = newIdx;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: (isFetchingChapters) ?
        Center(child: SizedBox(height: 50, width: 50, child: const CircularProgressIndicator(),),) :
        Scrollbar(
          child: ListView.builder(
              controller: controller,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Image.network(
                  items[index],
                  width: screenSize.width,
                  fit: BoxFit.fitWidth,
                );
              }
          )
        )
    );
  }

}

List<List<T>> splitArray<T>(List<T> list, int chunkSize) {
  List<List<T>> chunks = [];
  for (var i = 0; i < list.length; i += chunkSize) {
    chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
  }
  return chunks;
}