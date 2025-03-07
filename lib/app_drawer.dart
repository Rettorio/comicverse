import 'package:comicverse/app_router.dart';
import 'package:comicverse/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

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
              "Baca komik favorit-mu kapan saja dimana saja!",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              maxLines: 3,
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage("assets/drawer_header.jpeg"))),
          ),
          ListTile(
            leading: const Icon(LucideIcons.home),
            title: const Text("Home"),
            onTap: () => Navigator.of(context).toHomeScreen(),
          ),
          ListTile(
            leading: const Icon(LucideIcons.bookMarked),
            title: const Text("Library"),
            onTap: () => Navigator.of(context).toLibraryScreen(),
          ),
          ListTile(
            leading: const Icon(LucideIcons.history),
            title: const Text("History"),
            onTap: () => Navigator.of(context).toHistoryScreen(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(LucideIcons.logOut),
            title: const Text("Logout"),
            onTap: () => AuthService().signout(context: context),
          ),
        ],
      ),
    );
  }
}
