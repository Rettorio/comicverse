import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comicverse/model/user.dart';

var db = FirebaseFirestore.instance;

Future<void> createUserDoc({
  required String username,
  required String email,
  required String uid,
  String? photoUrl
}) async {
  final nameUrl = username.replaceAll(" ", "+");
  final photo = photoUrl ?? "https://ui-avatars.com/api/?size=128&name=$nameUrl&background=random&color=fff";
  final user = ComicUser(id: '', name: username, email: email, photo: photo);

  await db.collection("user").doc(uid).set(user.toFirestore());
}