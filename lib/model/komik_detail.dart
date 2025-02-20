import 'dart:convert';

import 'package:http/http.dart' as http;
class KomikDetail {
  final String title;
  final String desc;
  final String synopsis;
  final String image;
  final String type;
  final String author;
  final List<KomikChapter> chapters;

  KomikDetail({
    required this.title,
    required this.desc,
    required this.synopsis,
    required this.image,
    required this.type,
    required this.author,
    required this.chapters
  });

  factory KomikDetail.fromJson(Map<String, dynamic> json, List<KomikChapter> chapters) {
    return KomikDetail(
      title: json['title'],
      desc: json['desc'],
      synopsis: json['synopsis'],
      type: json['type'],
      author: json['author'],
      chapters: chapters,
      image: json['image']
    );
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

Future<KomikDetail> fetchKomikDetail(String slug) async {
  final response = await http.get(Uri.parse("https://api.i-as.dev/api/komiku/chapter/$slug"));
  if(response.statusCode == 200) {
    final responses = json.decode(response.body);
    final List<KomikChapter> chapters = responses["chapters"].map((e) => KomikChapter.fromJson(e));
    return KomikDetail.fromJson(responses, chapters);
  } else {
    throw Exception('Failed to load komik detail');
  }
}