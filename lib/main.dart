import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_lists/screens/cover_screen.dart';
import 'package:simple_lists/screens/main_menu_screen.dart';
import 'package:simple_lists/utils/list_manager.dart';
import 'package:simple_lists/utils/theme_manager.dart';
import 'package:simple_lists/widgets/foldable_aware.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => ListManager()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: 'Grocery List App',
            themeMode: themeManager.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: FoldableAware(
              unfoldedScreen: MainMenuScreen(),
              foldedScreen: CoverScreen(),
            ),
          );
        },
      ),
    );
  }
}
