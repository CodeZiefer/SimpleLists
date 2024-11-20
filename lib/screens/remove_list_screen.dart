import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoveListScreen extends StatefulWidget {
  @override
  _RemoveListScreenState createState() => _RemoveListScreenState();
}

class _RemoveListScreenState extends State<RemoveListScreen> {
  List<Map<String, dynamic>> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    _loadGroceryItems();
  }

  Future<void> _loadGroceryItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('groceryItems');
    if (items != null) {
      setState(() {
        _groceryItems = items.map((item) {
          final parts = item.split('|');
          return {
            'name': parts[0],
            'isChecked': parts[1] == 'true',
          };
        }).toList();
      });
    }
  }

  void _removeItem(int index) async {
    setState(() {
      _groceryItems.removeAt(index);
      _saveGroceryItems();
    });
  }

  Future<void> _saveGroceryItems() async {
    final prefs = await SharedPreferences.getInstance();
    final items = _groceryItems.map((item) {
      return '${item['name']}|${item['isChecked']}';
    }).toList();
    prefs.setStringList('groceryItems', items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remove Lists'),
      ),
      body: ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _groceryItems[index]['name'],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeItem(index),
            ),
          );
        },
      ),
    );
  }
}
