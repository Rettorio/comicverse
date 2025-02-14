import 'package:comicverse/home/library_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "ComicVerse",
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            accountEmail: Text(
              "Baca manga favorit-mu kapan saja dimana saja!",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              maxLines: 3,
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage("assets/coba5.jpeg"))),
          ),
          ListTile(
            leading: const Icon(LucideIcons.home),
            title: const Text("Home"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(LucideIcons.bookMarked),
            title: const Text("Library"),
            onTap: () {
              // Navigasi ke LibraryScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LibraryScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(LucideIcons.history),
            title: const Text("History"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(LucideIcons.logOut),
            title: const Text("Logout"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
