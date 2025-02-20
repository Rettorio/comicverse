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
  final tabs = [
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
  final screenSize = MediaQuery.of(context).size;
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
                    // _buildTabBottomSheet(context);
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
           FutureBuilder<List<Komik>>(
                future: _contentData,
                builder: (context, snapshot)  {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        width: screenSize.width,
                        height: 500,
                        child: Center(child: const CircularProgressIndicator(),),
                      ),
                    );
                  } else if(snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    final List<Komik> data = snapshot.data!;
                    return Expanded(
                          child: _buildMangaGrid(data)
                    );
                  } else {
                    return Text("Tidak ada data");
                  }
                }
            ),
        ],
      ),
    );
  }

  // Widget untuk Tab Navigasi
  Widget _buildTabNavigation() {
    return Row(
        children: [
          Expanded(
            child: TabBar(
              padding: const EdgeInsets.symmetric(vertical: 8),
              controller: tabController,// Warna indikator tab
              tabs: tabs.map((tab) {
                return Tab(text: tab.title,);
              }).toList(),
              onTap: _loadContent,
            ),
          )
        ]
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).toDetail(komik.toDetailScreenArgs()),
        child: Stack(
          children: [
            Hero(
              tag: "komik-photo-${komik.slug}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  komik.image,
                  fit: BoxFit.cover,
                  height: cardHeight,
                ),
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
                child: Hero(
                  tag: "komik-title-${komik.slug}",
                  child: Text(
                    komik.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              )
          ),
          ],
        ),
      ),
    );
  }
}
