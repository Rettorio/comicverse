import 'package:comicverse/history/history_screen.dart';
import 'package:comicverse/home/home_scren.dart';
import 'package:comicverse/library/library_screen.dart';
import 'package:comicverse/model/komik_detail.dart';
import 'package:flutter/material.dart';

import 'details/detail_scren.dart';

class AppRouter {
  static const homeRoute = "/";
  static const libraryRoute = "libraryRoute";
  static const historyRoute = "historyRoute";
  static const komikDetailRoute = "komikDetailRoute";

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {
      case homeRoute :
        return MaterialPageRoute(
            builder: (context) => const HomePage(),
            settings: settings
        );
      case libraryRoute :
        return MaterialPageRoute(
            builder: (context) => LibraryScreen(),
            settings: settings
        );
      case historyRoute :
        return MaterialPageRoute(
            builder: (context) => HistoryScreen(),
            settings: settings
        );
      case komikDetailRoute :
        return MaterialPageRoute(
            builder: (context) => MangaDetailPage(args: settings.arguments as DetailScreenArgs),
            settings: settings
        );
    }
    return null;
  }
}

extension NavigatorStateExtensions on NavigatorState {
  Future<void> toHomeScreen() =>
      pushNamed(AppRouter.homeRoute);

  Future<void> toLibraryScreen() =>
      pushNamed(AppRouter.libraryRoute);

  Future<void> toHistoryScreen() =>
      pushNamed(AppRouter.historyRoute);

  Future<void> toDetail(DetailScreenArgs args) =>
      pushNamed(AppRouter.komikDetailRoute, arguments: args);

}