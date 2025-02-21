import 'package:cloud_firestore/cloud_firestore.dart';

class ComicUser {
  final String id;
  final String name;
  final String email;
  final String photo;

  ComicUser({
    required this.id,
    required this.name,
    required this.email,
    required this.photo
  });

  factory ComicUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ComicUser(id: doc.id, name: data["name"], email: data["email"], photo: data["photo_profile"]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'photo_profile': photo,
      'name': name
    };
  }
}