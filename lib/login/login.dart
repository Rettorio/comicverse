import 'dart:async';

import 'package:comicverse/app_router.dart';
import 'package:comicverse/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  StreamSubscription<User?>? _authSubscription;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && context.mounted) {
        showSnackbar(context);
        _authSubscription?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void showSnackbar(BuildContext argContext) {
    ScaffoldMessenger.of(argContext).showSnackBar(
      const SnackBar(
        content: Text('Login berhasil!'),
        backgroundColor: Colors.white70,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    final TextEditingController _resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reset Password'),
          content: TextField(
            controller: _resetEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Masukkan email Anda',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = _resetEmailController.text.trim();
                if (email.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Email tidak boleh kosong.',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                } else {
                  await AuthService().resetPassword(email: email);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              child: Text('Kirim'),
            ),  
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/drawer_header.jpeg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'ComicVerse',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  "You're favorite comic reader",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.email, color: Colors.white70),
                  ),
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.lock, color: Colors.white70),
                  ),
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => AuthService().signin(
                      email: _emailController.text,
                      password: _passwordController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      await AuthService().signInWithGoogle();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google.jpeg',
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Login dengan Google',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => _showResetPasswordDialog(context),
                      child: Text(
                        'Lupa Password?',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Text(
                      '|',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).toRegisterScreen();
                      },
                      child: Text(
                        'Daftar Akun Baru',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}