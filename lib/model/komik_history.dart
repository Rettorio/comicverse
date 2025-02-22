import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comicverse/model/komik_detail.dart';

class KomikHistory {
  final String title;
  final String uid;
  final String id;
  final List<String> chapters;
  final String image;
  final String slug;
  final Timestamp terakhirBaca;

  KomikHistory({
    this.id = '',
    required this.title,
    this.uid = '',
    required this.image,
    required this.slug,
    this.chapters = const [],
    required this.terakhirBaca
  });

  void setNewChapter(String chapter) {
    chapters.add(chapter);
  }

   DetailScreenArgs toDetailScreenArgs() {
     return DetailScreenArgs(slug: slug, title: title, image: image);
   }

  // Convert a KomikHistory object to a Map for Firestore
  Map<String, dynamic> toFirestore(String uid) {
    return {
      'id': id,
      'slug': slug,
      'uid': uid,
      'title': title,
      'chapters': chapters,
      'image': image,
      'terakhirBaca': terakhirBaca,
    };
  }

  // Convert a Firestore document snapshot to a KomikHistory object
  static KomikHistory fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return KomikHistory(
      id: doc.id,
      uid: data['uid'],
      title: data['title'],
      chapters: data['chapters'].cast<String>(),
      image: data['image'],
      terakhirBaca: data['terakhirBaca'],
      slug: data['slug']
    );
  }
}