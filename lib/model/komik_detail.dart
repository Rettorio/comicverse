import 'dart:convert';

import 'package:http/http.dart' as http;

import 'komik_library.dart';
class KomikDetail {
  final String slug;
  final String title;
  final String desc;
  final String synopsis;
  final String image;
  final String type;
  final String author;
  final String status;
  final List<KomikChapter> chapters;

  KomikDetail({
    required this.slug,
    required this.title,
    required this.desc,
    required this.synopsis,
    required this.image,
    required this.type,
    required this.author,
    required this.chapters,
    required this.status
  });

  factory KomikDetail.fromJson(Map<String, dynamic> json, List<KomikChapter> chapters, String slug) {
    return KomikDetail(
      title: json['title'],
      slug: slug,
      desc: json['desc'],
      synopsis: json['synopsis'],
      type: json['type'],
      author: json['author'],
      chapters: chapters,
      image: json['image'],
      status: json['status']
    );
  }

  KomikLibrary toKomikLibrary()  {
    return KomikLibrary(title: title, id: '', image: image, slug: slug, author: author, totalChapter: chapters.length, totalChapterbaca: 0);
  }
}

class KomikChapter{
  final String title;
  final String slug;
  final String views;
  final String date;

  KomikChapter({
    required this.title,
    required this.slug,
    required this.views,
    required this.date
  });

  factory KomikChapter.fromJson(Map<String, dynamic> json) {
    return KomikChapter(
      title: json['title'],
      slug: json['slug'],
      views: json['views'],
      date: json['date'],
    );
  }
}

class DetailScreenArgs {
  final String slug;
  final String title;
  final String image;

  DetailScreenArgs({
    required this.slug,
    required this.title,
    required this.image
  });
}

Future<KomikDetail> fetchKomikDetail(String slug) async {
  final response = await http.get(Uri.parse("https://api.i-as.dev/api/komiku/detail/$slug"));
  if(response.statusCode == 200) {
    final responses = json.decode(response.body);
    final List<dynamic> chapterJson = json.decode(response.body)['chapters'];
    final List<KomikChapter> chapters = chapterJson.map((e) => KomikChapter.fromJson(e)).toList();
    return KomikDetail.fromJson(responses, chapters, slug);
  } else {
    throw Exception('Failed to load komik detail');
  }
}

Future<List<String>> fetchKomikChapter(String slug) async {
  final response = await http.get(Uri.parse("https://api.i-as.dev/api/komiku/chapter/$slug"));
  if(response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body)["chapter"];
    final List<String> chapters = jsonData.map((data) => data['image'].toString()).toList();
    return chapters;
  } else {
    throw Exception("Failed to load komik chapters");
  }
}