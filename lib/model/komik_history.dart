import 'package:cloud_firestore/cloud_firestore.dart';

class KomikHistory {
  final String title;
  final String lastChapter;
  final String image;
  final String slug;
  final Timestamp terakhirBaca;

  KomikHistory({
    required this.title,
    required this.image,
    required this.slug,
    required this.lastChapter,
    required this.terakhirBaca
  });

  // Convert a KomikHistory object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'lastChapter': lastChapter,
      'image': image,
      'terakhirBaca': terakhirBaca,
      'slug': slug
    };
  }

  // Convert a Firestore document snapshot to a KomikHistory object
  static KomikHistory fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return KomikHistory(
      title: data['title'],
      lastChapter: data['lastChapter'],
      image: data['image'],
      terakhirBaca: data['terakhirBaca'],
      slug: data['slug']
    );
  }
}