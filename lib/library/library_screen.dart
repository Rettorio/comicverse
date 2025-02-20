import 'package:comicverse/app_drawer.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  // Dummy data untuk daftar manga
  final List<Map<String, String>> mangaList = [
    {
      'title': 'One Piece',
      'author': 'Eiichiro Oda',
      'cover': 'https://via.placeholder.com',
      'lastReadDate': '2023-10-01',
      'lastChapter': 'Chapter 1050',
    },
    {
      'title': 'Naruto',
      'author': 'Masashi Kishimoto',
      'cover': 'https://via.placeholder.com',
      'lastReadDate': '2023-09-25',
      'lastChapter': 'Chapter 700',
    },
    // Tambahkan lebih banyak manga di sini
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: mangaList.length,
          itemBuilder: (context, index) {
            final manga = mangaList[index];
            return MangaCard(
              title: manga['title']!,
              author: manga['author']!,
              cover: manga['cover']!,
              lastReadDate: manga['lastReadDate']!,
              lastChapter: manga['lastChapter']!,
            );
          },
        ),
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
      elevation: 2.0, // Shadow yang lebih halus
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.only(bottom: 16.0), // Jarak antar kartu
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar cover manga
          ClipRRect(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(8.0),
            ),
            child: Image.network(
              cover,
              width: 100, // Lebar gambar
              height: 150, // Tinggi gambar
              fit: BoxFit.cover,
            ),
          ),
          // Informasi manga
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
                    'Terakhir dibaca: $lastReadDate',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Chapter: $lastChapter',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tombol play dalam bentuk teks
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
                  color: Colors.blue, // Warna teks bisa disesuaikan
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}