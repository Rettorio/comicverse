import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/firestore.dart';

class AuthService {
  Future<void> signup(
      {required String email,
        required String username,
        required String password}) async {
    try {
      final userCreds = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await createUserDoc(username: username, email: email, uid: userCreds.user!.uid);

    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Password terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Akun dengan email ini sudah terdaftar.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signin(
      {required String email,
        required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // await Future.delayed(const Duration(seconds: 1));
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (BuildContext context) => const Home()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'User dengan email ini tidak terdaftar.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signout({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();
    // await Future.delayed(const Duration(seconds: 1));
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (BuildContext context) => const Login()));
  }
}