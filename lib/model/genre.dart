import 'dart:convert';

import 'package:comicverse/home/tab_content.dart';
import 'package:http/http.dart' as http;
class GenreKomik {
  final String title;
  final String slug;

  GenreKomik({required this.title, required this.slug});

  factory GenreKomik.fromJson(Map<String, dynamic> json) {
    return GenreKomik(
      title: json['title'] as String,
      slug: json['slug'] as String,
    );
  }

  TabContent toTabContent() {
    return TabContent(title: title, slug: slug, collector:  TabContent.collectorMaker(this.slug));
  }
}

Future<List<GenreKomik>> fetchGenre() async {
  final response = await http.get(Uri.parse("https://api.i-as.dev/api/komiku/genre/"));
  if(response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body)["genre"];
    return jsonData.map((row) => GenreKomik.fromJson(row)).toList();
  } else {
    throw Exception("Tidak dapat mengambil data genre");
  }
}