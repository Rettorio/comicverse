import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comicverse/data/firestore.dart';
import 'package:comicverse/model/komik_detail.dart';
import 'package:comicverse/model/komik_history.dart';
import 'package:flutter/material.dart';

class MangaDetailPage extends StatefulWidget {
  final DetailScreenArgs args;
  const MangaDetailPage({super.key, required this.args});

  @override
  State<MangaDetailPage> createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage> {
  bool isSaved = false;
  KomikHistory? history;
  late Future<KomikDetail> futureData;
  
  @override
  void initState() {
    super.initState();
    futureData = fetchKomikDetail(widget.args.slug);
    fetchUserKomikInLibrary(widget.args.slug).then((exist) {
      setState(() {
        isSaved = exist;
      });
    });
    fetchKomikHistory(widget.args.slug).then((data) {
      if(data != null) {
        history = data;
      }
    });
  }
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
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover Komik
                    Hero(
                      tag: "komik-photo-${widget.args.slug}",
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.args.image, // Ganti dengan URL cover komik
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    // Judul, Penulis, dan Tag
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: "komik-title-${widget.args.slug}",
                            child: Text(
                              widget.args.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 8),
                          FutureBuilder(
                              future: futureData,
                              builder: (context, snapshot) {
                                if(snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                                  return SizedBox(
                                    height: 300,
                                    width: 100,
                                  );
                                }
                                final komik = snapshot.data;
                                if(komik == null) {
                                  return SizedBox(
                                    height: 300,
                                    width: 100,
                                  );
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                );
                              }
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                FutureBuilder(
                    future: futureData,
                    builder: (context, snapshot) {
                      if(snapshot.hasError) {
                        return Center(child: Text("Something went wrong ${snapshot.error}"));
                      }
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final komik = snapshot.data;
                      if(komik == null) {
                        return Expanded(child: Center(child: Text("tidak ada komik")));
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    onPressed: () async {
                                      if(!isSaved) {
                                        final libraryInstance = komik.toKomikLibrary();
                                        await addToLibrary(libraryInstance);
                                        setState(() {
                                          isSaved = true;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[800],
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(isSaved ? Icons.bookmark : Icons.bookmark_add_rounded, size: 24,),
                                        const SizedBox(width: 5,),
                                        Text(
                                          isSaved ? "disimpan" : 'Simpan',
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
                                  komik.chapters[0].title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Latest Chapter',
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
                                onTap: () {
                              
                                  if(history == null) {
                                    history = KomikHistory(
                                      title: komik.title,
                                      image: komik.image,
                                      slug: komik.slug,
                                      chapters: [komik.chapters[index].slug],
                                      terakhirBaca: Timestamp.now(),
                                      );
                                      createOrUpdateHistory(history!);
                                  } else {
                                    history!.setNewChapter(komik.chapters[index].slug);
                                    createOrUpdateHistory(history!);
                                  }
                                },
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(Icons.menu, color: Colors.grey[400]),
                                title: Text(
                                  komik.chapters[index].title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  komik.chapters[index].date,
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
                      );
                    }
                )
              ],
            ),
          )
      ),
    );
  }
}