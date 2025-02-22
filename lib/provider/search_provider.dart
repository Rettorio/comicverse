import 'package:comicverse/home/tab_content.dart';
import 'package:comicverse/model/komik.dart';
import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier {
  String _searchText = '';
  TabContentCollector? _contentCollector;

  String get searchText => _searchText;
  Future<List<Komik>>? get contentCollector {
    if(_contentCollector != null) return _contentCollector!();
    return null;
  }

  void updateSearchText(String newText) {
    _searchText = newText;
    notifyListeners();
  }

  void updateContentCollector(TabContentCollector collector) {
    _contentCollector = collector;
    notifyListeners();
  }
}