import 'package:comicverse/app_router.dart';
import 'package:comicverse/home/home_scren.dart';
import 'package:comicverse/login/login.dart';
import 'package:comicverse/provider/auth_provider.dart';
import 'package:comicverse/provider/search_provider.dart';
import 'package:comicverse/theme/theme.dart';
import 'package:comicverse/theme/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: "ComicVerse"
  );
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SearchProvider()),
          ChangeNotifierProvider(create: (_) => AppAuthProvider())
        ],
      child: MyApp(),
    )
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      theme: theme.dark(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AppAuthProvider>();

    if (authProvider.user == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}