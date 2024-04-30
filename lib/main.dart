import 'package:basa_proj_app/providers/book_provider.dart';
import 'package:basa_proj_app/ui/screens/help_screen.dart';
import 'package:basa_proj_app/ui/screens/library_screen.dart';
import 'package:basa_proj_app/ui/screens/online_library_screen.dart';
import 'package:flutter/material.dart';
import 'package:basa_proj_app/ui/screens/menu_page.dart';
import 'package:basa_proj_app/ui/screens/ibasa_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yylntypflmogsgbcluhn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5bG50eXBmbG1vZ3NnYmNsdWhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTQyOTE3MTcsImV4cCI6MjAyOTg2NzcxN30.f9skV7TQ2kNYzc--_K4lDAzQ6qX6wAkEUeraCZWPWiQ',
  );

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Basa App',
      theme: ThemeData(
        focusColor: ConstantUI.customBlue,
        primaryColor: ConstantUI.customBlue,
        scaffoldBackgroundColor: ConstantUI.customYellow,
        fontFamily: ITIM_FONTNAME,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuPage(),
        '/ibasa': (context) => IbasaScreen(),
        '/onlinelib': (context) => OnlineLibraryScreen(),
        '/library': (context) => LibraryScreen(),
        '/help': (context) => HelpScreen(),
      },
    );
  }
}
