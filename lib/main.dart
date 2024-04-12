import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/ui/screens/menu_page.dart';
import 'package:basa_proj_app/ui/screens/ibasa_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => BookProvider(),
      child: const BasaApp(),
    ),
  );
}

class BasaApp extends StatelessWidget {
  const BasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basa App',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuPage(),
        '/ibasa': (context) => IbasaScreen(),
        // '/dict': (context) => DictionaryScreen(),
        // '/library': (context) => LibraryScreen(),
        // '/setting': (context) => SettingScreen(),
        // '/help': (context) => HelpScreen(),
      },
    );
  }
}
