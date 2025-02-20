import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              // Gambar Ilustrasi Manga
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/drawer_header.jpeg', // Ganti dengan path gambar Anda
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              // Judul Aplikasi
              Text(
                'Daftar Akun',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins', // Gunakan font kustom jika ada
                ),
              ),
              SizedBox(height: 40),
              // Input Field Nama
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Nama',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.person, color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              // Input Field Email
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
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              // Input Field Password
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
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 30),
              // Tombol Daftar
              ElevatedButton(
                onPressed: () {
                  // Aksi saat tombol daftar ditekan
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Daftar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Opsi Login
              TextButton(
                onPressed: () {
                  // Navigasi ke halaman login
                },
                child: Text(
                  'Sudah punya akun? Masuk',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}