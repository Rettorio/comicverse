import 'dart:ui';
import 'package:comicverse/app_drawer.dart';
import 'package:comicverse/app_router.dart';
import 'package:comicverse/home/tab_content.dart';
import 'package:comicverse/model/genre.dart';
import 'package:comicverse/model/komik.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  Future<List<Komik>>? _contentData;
  final List<TabContent> tabs = [
    TabContent(title: "Latest", slug: "latest", collector: fetchKomik),
    TabContent(title: "Mecha", slug: "mecha", collector: TabContent.collectorMaker("mecha")),
    TabContent(title: "Isekai", slug: "isekai", collector: TabContent.collectorMaker("isekai")),
  ];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<GenreKomik> genreKomik = List.empty();
  
  Future<void> loadGenre() async {
    if(genreKomik.isEmpty) {
      try {
        final data = await fetchGenre();
        debugPrint("first genre : ${data[0].slug}");
        genreKomik = data;
    } catch (e) {
        return;
      }
    }
    return;
  }

  bool isGenreInTab(String genre) {
    return tabs.where((e) => e.slug == genre).toList().length > 1;
  }

@override
void initState() {
  super.initState();
  tabController = TabController(length: tabs.length, vsync: this);
  _loadContent(0);
}

void _loadContent(int activeTab) {
  setState(() {
    _contentData = tabs[activeTab].collector();
  });
}

  @override
  Widget build(BuildContext context) {
    loadGenre();
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'ComicVerse',
          style: TextStyle(color: Colors.white), // Teks putih
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu), // Ikon menu
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            tooltip: "show more",
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.search),
                    const SizedBox(width: 5,),
                    const Text("Cari Komik")
                  ],
                )
              ),
              PopupMenuItem(
                  onTap: () {
                    _buildTabBottomSheet(context);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.settings),
                      const SizedBox(width: 5,),
                      const Text("Atur Tab Genre")
                    ],
                  )
              )
            ]
          )
        ],
      ),
      body: Column(
        children: [
          // Tab Navigasi
          _buildTabNavigation(),
          // Daftar Manga (bungkus dengan Expanded agar fleksibel)
          Expanded(
            child: FutureBuilder<List<Komik>>(
                future: _contentData,
                builder: (context, snapshot)  {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  } else if(snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    final List<Komik> data = snapshot.data!;
                    return _buildMangaGrid(data);
                  } else {
                    return Text("Tidak ada data");
                  }
                }
            ),
          ),
        ],
      ),
    );
  }

  Future _buildTabBottomSheet(BuildContext context) async {
    await loadGenre();
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox.expand(
            child: Container(
              margin: const EdgeInsets.only(top: 14, left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Genre Komik Untuk ditampilkan :",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 5.0,
                    children: genreKomik.map((genre) {
                      return FilterChip(
                        label: Text(genre.title),
                        onSelected: (select) => {
                          setState(() {
                            tabs.add(genre.toTabContent());
                          })
                        },
                        selected: isGenreInTab(genre.slug),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          );
        }
    );
  }
  // Widget untuk Tab Navigasi
  Widget _buildTabNavigation() {
    return Container(// Warna latar tab
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: tabController,// Warna indikator tab
              tabs: tabs.map((tab) {
                return Tab(text: tab.title,);
              }).toList(),
              onTap: _loadContent,
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.add, color: Colors.white), // Tombol tambah
          //   onPressed: () {
          //   },
          // ),
        ],
      ),
    );
  }

  // Widget untuk Daftar Manga dalam Grid
  Widget _buildMangaGrid(List<Komik> mangaList) {

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 2 kolom
        crossAxisSpacing: 16, // Jarak antar kolom
        mainAxisSpacing: 16, // Jarak antar baris
        childAspectRatio: 0.7, // Rasio tinggi dan lebar item
      ),
      itemCount: mangaList.length,
      itemBuilder: (context, index) {
        return _buildMangaItem(mangaList[index], context);
      },
    );
  }

  // Widget untuk Item Manga
  Widget _buildMangaItem(Komik komik, BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width;
    final cardHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => Navigator.of(context).toDetail(komik.toDetailScreenArgs()),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                komik.image,
                fit: BoxFit.cover,
                height: cardHeight,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur intensity
                  child: Container(
                    width: cardWidth,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4), // Optional: Rounded corners
                    )
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: SizedBox(
                width: cardWidth * 0.4,
                child: Text(
                  komik.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis
                  ),
                  textAlign: TextAlign.start,
                ),
              )
          ),
          ],
        ),
      ),
    );
  }
}
