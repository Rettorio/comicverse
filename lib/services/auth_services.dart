import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In

import '../data/firestore.dart';

class AuthService {
  Future<void> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final userCreds = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await createUserDoc(
          username: username, email: email, uid: userCreds.user!.uid);
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

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'User dengan email ini tidak terdaftar.';
      } else if (e.code == 'invalid-credential') {
        message = 'Password yang dimasukkan salah.';
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
  }

  // 🌟 🔥 Fungsi Login dengan Google 🔥 🌟
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User batal login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Cek apakah user baru, jika ya, buat dokumen di Firestore
      if (userCredential.additionalUserInfo!.isNewUser) {
        await createUserDoc(
          username: userCredential.user!.displayName ?? 'GoogleUser',
          email: userCredential.user!.email ?? '',
          uid: userCredential.user!.uid,
        );
      }

      Fluttertoast.showToast(
        msg: 'Login Google berhasil!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Login Google gagal: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  // 🌟 🔑 Fungsi Reset Password 🔑 🌟
  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: 'Email reset password telah dikirim ke $email.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan. Coba lagi.';
      if (e.code == 'user-not-found') {
        message = 'Email tidak ditemukan. Periksa kembali.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }
}
