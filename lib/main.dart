import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './utils/theme_manager.dart';
import 'screens/main_menu_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: 'Grocery List App',
            themeMode: themeManager.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: MainMenuScreen(),
          );
        },
      ),
    );
  }
}
