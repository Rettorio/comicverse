import 'package:comicverse/model/komik_detail.dart';
import 'package:flutter/material.dart';

class MangaDetailPage extends StatelessWidget {
  final String detailSlug;
  const MangaDetailPage({super.key, required this.detailSlug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Aksi untuk menu tiga titik
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child:  FutureBuilder(
              future: fetchKomikDetail(detailSlug),
              builder: (context, snapshot) {
                if(snapshot.hasError) {
                  return Expanded(child: Center(child: Text("Something went wrong ${snapshot.error}"),));
                }
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(child: Center(child: CircularProgressIndicator()));
                }
                final komik = snapshot.data;
                if(komik == null) {
                  return Expanded(child: Center(child: Text("tidak ada komik")));
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cover & Detail Komik
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cover Komik
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                komik.image, // Ganti dengan URL cover komik
                                width: 120,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            // Judul, Penulis, dan Tag
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    komik.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    komik.author,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      Chip(
                                        label: Text(komik.status, style: TextStyle(color: Colors.white)),
                                        backgroundColor: Colors.blue[800],
                                      ),
                                      Chip(
                                        label: Text(komik.type, style: TextStyle(color: Colors.white)),
                                        backgroundColor: Colors.blue[800],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Deskripsi Komik
                        Text(
                          komik.synopsis,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          maxLines: 10,
                        ),
                        SizedBox(height: 24),
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi untuk tombol Resume
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[800],
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.play_circle, size: 24,),
                                    const SizedBox(width: 5,),
                                    Text(
                                      'Lanjut',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi untuk tombol Liked
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.bookmark_add_rounded, size: 24,),
                                    const SizedBox(width: 5,),
                                    Text(
                                      'Simpan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        // Daftar Chapter
                        Text(
                          'Chapters',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Chapter Terbaru
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chapter ${komik.chapters.length - 1}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'New Chapter',
                                style: TextStyle(
                                  color: Colors.blue[300],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Daftar Chapter Lainnya
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: komik.chapters.length, // Ganti dengan jumlah chapter yang sesuai
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.menu, color: Colors.grey[400]),
                              title: Text(
                                'Chapter ${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                '2 days ago',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                                onPressed: () {
                                  // Aksi untuk menu tiga titik di setiap chapter
                                },
                              ),
                            );
                          },
                        ),
                      ],
                  ),
                );
              }
          ),
        ),
    );
  }
}