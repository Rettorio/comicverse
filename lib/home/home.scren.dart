import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;

@override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Warna latar belakang gelap
      appBar: AppBar(
        backgroundColor: Colors.black, // Warna header gelap
        title: const Text(
          'My Manga',
          style: TextStyle(color: Colors.white), // Teks putih
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white), // Ikon menu
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white), // Ikon pencarian
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Navigasi
          _buildTabNavigation(),
          // Daftar Manga (bungkus dengan Expanded agar fleksibel)
          Expanded(
            child: _buildMangaGrid(),
          ),
        ],
      ),
    );
  }

  // Widget untuk Tab Navigasi
  Widget _buildTabNavigation() {
    return Container(
      color: Colors.black, // Warna latar tab
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.white, // Warna indikator tab
              tabs: const [
                Tab(text: 'Reading Now'),
                Tab(text: 'My Favourites'),
                Tab(text: 'To Read'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white), // Tombol tambah
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Widget untuk Daftar Manga dalam Grid
  Widget _buildMangaGrid() {
    final List<String> mangaList = [
      '19 Tian',
      'Solo Leveling',
      'One Piece',
      'Naruto',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom
        crossAxisSpacing: 16, // Jarak antar kolom
        mainAxisSpacing: 16, // Jarak antar baris
        childAspectRatio: 0.7, // Rasio tinggi dan lebar item
      ),
      itemCount: mangaList.length,
      itemBuilder: (context, index) {
        return _buildMangaItem(mangaList[index]);
      },
    );
  }

  // Widget untuk Item Manga
  Widget _buildMangaItem(String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[800], // Warna latar item
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white, // Teks putih
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
