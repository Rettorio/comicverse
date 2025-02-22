import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AppAuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  AppAuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners(); // Notify when auth state changes
    });
  }
}