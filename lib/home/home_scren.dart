import 'package:flutter/material.dart';
import 'package:comicverse/widgets/skeleton_loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isLoading = true;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: isLoading
            ? const SkeletonAnimation(width: 140, height: 28)
            : const Text('My Manga', style: TextStyle(color: Color.fromARGB(255, 255, 215, 0))),
        centerTitle: true,
        leading: isLoading
            ? const SkeletonAnimation(width: 40, height: 40)
            : IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {},
              ),
        actions: [
          isLoading
              ? const SkeletonAnimation(width: 40, height: 40)
              : IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          _buildTabNavigation(),
          Expanded(
            child: isLoading ? const SkeletonScreen() : _buildMangaGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SkeletonAnimation(width: 110, height: 36),
                      const SkeletonAnimation(width: 110, height: 36),
                      const SkeletonAnimation(width: 110, height: 36),
                    ],
                  )
                : TabBar(
                    controller: tabController,
                    indicatorColor: Colors.white,
                    tabs: const [
                      Tab(text: 'Reading Now'),
                      Tab(text: 'My Favourites'),
                      Tab(text: 'To Read'),
                    ],
                  ),
          ),
          
        ],
      ),
    );
  }

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
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: mangaList.length,
      itemBuilder: (context, index) {
        return _buildMangaItem(mangaList[index]);
      },
    );
  }

  Widget _buildMangaItem(String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[800],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
