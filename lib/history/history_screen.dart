import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comicverse/data/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comicverse/model/komik_history.dart'; 
import 'package:comicverse/app_drawer.dart'; 
import 'package:intl/intl.dart'; // Import package intl

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  String getLastChapterString(String source) {
    RegExp regExp = RegExp(r'chapter-\d+');
    Match? match = regExp.firstMatch(source);
    return match?.group(0) ?? source;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<KomikHistory>>(
        future: fetchAllKomikHistory(), // Ambil data history
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if(snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data history.'));
          }
            final historyList = snapshot.data!;
            return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final history = historyList[index];
                final String lastChapter = getLastChapterString(history.chapters.last);
                final String formattedDate = DateFormat('yyyy-MM-dd').format(history.terakhirBaca.toDate()); // Format tanggal
                return HistoryCard(
                  title: history.title,
                  cover: history.image,
                  lastReadDate: 'Terakhir dibaca: $formattedDate', // Gunakan tanggal yang sudah diformat
                  lastChapter: lastChapter,
                  onDelete: () {
                    // Hapus entri history
                    // _firestore.collection('komik_history').doc(history.id).delete();
                  },
                );
              },
            ),
          );
        },
      ),
      drawer: AppDrawer(),
      backgroundColor: Colors.black,
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String title;
  final String cover;
  final String lastReadDate;
  final String lastChapter;
  final VoidCallback onDelete;

  const HistoryCard({
    required this.title,
    required this.cover,
    required this.lastReadDate,
    required this.lastChapter,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Colors.grey[900],
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
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    lastReadDate,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    lastChapter,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}