import 'package:comicverse/app_drawer.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  // Dummy data untuk history bacaan
  final List<Map<String, String>> historyEntries = [
    {
      'coverImage': 'assets/drawer_header.jpeg',
      'title': 'Komik Pertama',
      'chapter': 'Chapter 10',
      'lastRead': '2 jam yang lalu',
      'date': '2023-10-01'
    },
    {
      'coverImage': 'assets/drawer_header.jpeg',
      'title': 'Komik Kedua',
      'chapter': 'Chapter 5',
      'lastRead': '1 hari yang lalu',
      'date': '2023-09-30'
    },
    {
      'coverImage': 'assets/drawer_header.jpeg',
      'title': 'Komik Ketiga',
      'chapter': 'Chapter 20',
      'lastRead': '3 hari yang lalu',
      'date': '2023-09-28'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black, // AppBar dark mode
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: historyEntries.length,
        itemBuilder: (context, index) {
          final entry = historyEntries[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tanggal grup
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  entry['date']!,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              // Kartu untuk menampilkan entri history
              Card(
                color: Colors.grey[900], // Warna latar belakang kartu
                elevation: 2, // Bayangan kartu
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Sudut melengkung
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      entry['coverImage']!,
                      width: 50,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    entry['title']!,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${entry['chapter']} - ${entry['lastRead']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      // Aksi untuk menghapus entri
                    },
                  ),
                ),
              ),
              SizedBox(height: 8), // Jarak antar kartu
            ],
          );
        },
      ),
      drawer: AppDrawer(),
      backgroundColor: Colors.black, // Latar belakang hitam
    );
  }
}