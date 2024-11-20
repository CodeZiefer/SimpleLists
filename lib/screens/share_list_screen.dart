import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class ShareListScreen extends StatelessWidget {
  List<String> _groceryItems = [];

  Future<void> _loadGroceryItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('groceryItems');
    if (items != null) {
      _groceryItems = items;
    }
  }

  void _shareList(BuildContext context) async {
    await _loadGroceryItems();
    final String items = _groceryItems.map((item) {
      final parts = item.split('|');
      return parts[0]; // Only include the item name
    }).join('\n');
    Share.share(items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Lists'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _shareList(context),
          child: Text('Share Grocery List'),
        ),
      ),
    );
  }
}
