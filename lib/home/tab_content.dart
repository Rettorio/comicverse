import 'package:comicverse/model/komik.dart';

typedef TabContentCollector = Future<List<Komik>> Function();

class TabContent {
  final String title;
  final String slug;
  final TabContentCollector collector;

  TabContent({required this.title, required this.slug, required this.collector});

  static TabContentCollector collectorMaker(String slug) {
    return () => fetchKomikByGenre(slug);
  }
}