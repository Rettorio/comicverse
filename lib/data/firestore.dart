import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comicverse/model/komik_history.dart';
import 'package:comicverse/model/komik_library.dart';
import 'package:comicverse/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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

Future<void> addToLibrary(KomikLibrary komik) async {
  final authorUid = FirebaseAuth.instance.currentUser?.uid;
  if(authorUid == null) {
    throw Exception("Cannot find user instance. login first!");
  }
  await db.collection("library").add(komik.toFirestore(authorUid));
}

Future<void> createOrUpdateHistory(KomikHistory history) async {
  try {
    if(history.id == '') {
      await db.collection("history").add(history.toFirestore());
    } else {
      await db.collection("history").doc(history.id).set(history.toFirestore());
    }
  } catch (e) {
    debugPrint('Error creating/updating document: $e');
    // throw e;
  }
}

Future<KomikHistory?> fetchKomikHistory(String komikSlug) async {
  final authorUid = FirebaseAuth.instance.currentUser?.uid;
  if(authorUid == null) {
    throw Exception("Cannot find user instance. login first!");
  }
  final fetchCollection = await db.collection("history").where("slug", isEqualTo: komikSlug).where("uid", isEqualTo: authorUid).limit(1).get();
  if(fetchCollection.docs.isNotEmpty) {
    return KomikHistory.fromFirestore(fetchCollection.docs.first);
  } else {
    return null;
  }
}

Future<List<KomikLibrary>> fetchUserLibrary() async {
  final authorUid = FirebaseAuth.instance.currentUser?.uid;
  if(authorUid == null) {
    throw Exception("Cannot find user instance. login first!");
  }
  final fetchCollection = await db.collection("library").where("uid", isEqualTo: authorUid).get();
  return fetchCollection.docs.map((doc) => KomikLibrary.fromFirestore(doc)).toList();
}

Future<bool> fetchUserKomikInLibrary(String slug) async {
  final authorUid = FirebaseAuth.instance.currentUser?.uid;
  if(authorUid == null) {
    throw Exception("Cannot find user instance. login first!");
  }
  final data = await db.collection("library").where("uid", isEqualTo: authorUid).where("slug", isEqualTo: slug).limit(1).get();
  return data.docs.isNotEmpty;
}