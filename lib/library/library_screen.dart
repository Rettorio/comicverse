import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comicverse/data/firestore.dart';
import 'package:comicverse/model/komik_library.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comicverse/app_drawer.dart';


class LibraryScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
/*************  ✨ Codeium Command ⭐  *************/
  /// Membuat widget untuk menampilkan daftar komik di library.
  //
  /// Widget ini menggunakan StreamBuilder untuk mengambil data dari Firestore
  /// dan menampilkan daftar komik di library. Jika data belum tersedia maka
  /// akan ditampilkan CircularProgressIndicator. Jika data kosong maka akan
  /// ditampilkan pesan bahwa tidak ada data komik di library. Jika data ada
/******  ac64db5a-5bda-4144-b5ad-a75c4762e3c0  *******/  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<KomikLibrary>>(
        future: fetchUserLibrary(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data komik di library.'));
          }

          final komikList = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: komikList.length,
              itemBuilder: (context, index) {
                final komik = komikList[index];
                return MangaCard(
                  title: komik.title,
                  author: komik.author,
                  cover: komik.image,
                  lastReadDate: 'Terakhir dibaca: Chapter ${komik.totalChapterbaca}',
                  lastChapter: 'Total Chapter: ${komik.totalChapter}',
                );
              },
            ),
          );
        },
      ),
      drawer: AppDrawer(),
    );
  }
}

class MangaCard extends StatelessWidget {
  final String title;
  final String author;
  final String cover;
  final String lastReadDate;
  final String lastChapter;

  const MangaCard({
    required this.title,
    required this.author,
    required this.cover,
    required this.lastReadDate,
    required this.lastChapter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(8.0),
            ),
            child: Image.network(
              cover,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Oleh: $author',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    lastReadDate,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    lastChapter,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextButton(
              onPressed: () {
                // Aksi ketika tombol play ditekan
              },
              child: Text(
                'Kunjungi',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}