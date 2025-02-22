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
    required this.id,
    required this.title,
    required this.uid,
    required this.image,
    required this.slug,
    required this.chapters,
    required this.terakhirBaca
  });

   DetailScreenArgs toDetailScreenArgs() {
     return DetailScreenArgs(slug: slug, title: title, image: image);
   }

  // Convert a KomikHistory object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': '',
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
      chapters: data['chapters'],
      image: data['image'],
      terakhirBaca: data['terakhirBaca'],
      slug: data['slug']
    );
  }
}