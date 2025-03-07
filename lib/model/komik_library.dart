import 'package:cloud_firestore/cloud_firestore.dart';

import 'komik_detail.dart';

class KomikLibrary {
  final String id;
  final String title;
  final String author;
  final String image;
  final String slug;
  final String? uid;
  final int totalChapter;
  final int totalChapterbaca;

  KomikLibrary({
    required this.title,
    this.id = '',
    this.uid,
    required this.image,
    required this.slug,
    required this.author,
    required this.totalChapter,
    required this.totalChapterbaca
  });

  DetailScreenArgs toDetailScreenArgs() {
    return DetailScreenArgs(slug: slug, title: title, image: image);
  }

  // Convert a KomikLibrary object to a Map for Firestore
  Map<String, dynamic> toFirestore(String uid) {
    return {
      'uid': uid,
      'title': title,
      'author': author,
      'image': image,
      'slug': slug,
      'totalChapter': totalChapter,
      'totalChapterbaca': totalChapterbaca,
    };
  }

  // Convert a Firestore document snapshot to a KomikLibrary object
  static KomikLibrary fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return KomikLibrary(
      id: doc.id,
      uid: data['uid'],
      title: data['title'],
      author: data['author'],
      image: data['image'],
      slug: data['slug'],
      totalChapter: data['totalChapter'],
      totalChapterbaca: data['totalChapterbaca'],
    );
  }
}