import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_manager.dart';
import 'list_screen.dart';
import '../widgets/list_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  Map<String, List<Map<String, dynamic>>> _lists = {};

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _loadLists() async {
    final prefs = await SharedPreferences.getInstance();
    final String? listsString = prefs.getString('lists');
    if (listsString != null) {
      setState(() {
        _lists = Map<String, List<Map<String, dynamic>>>.from(
          jsonDecode(listsString).map((key, value) => MapEntry(key, List<Map<String, dynamic>>.from(value))),
        );
      });
    }
    print('Lists loaded: $_lists');
  }

  Future<void> _saveLists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lists', jsonEncode(_lists));
  }

  void _navigateToListScreen(String listName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListScreen(
          listName: listName,
          items: _lists[listName]!,
          onSave: (items) {
            setState(() {
              _lists[listName] = items;
            });
            _saveLists();
            print('List "$listName" saved.');
          },
        ),
      ),
    );
  }

  void _addNewList(String listName) {
    setState(() {
      _lists[listName] = [];
    });
    _saveLists();
    print('New list "$listName" added.');
  }

  void _deleteList(String listName) {
    print('Deleting list: $listName');
    setState(() {
      _lists.remove(listName);
      _saveLists();
      print('List "$listName" removed from state.');
    });
    print('List "$listName" deletion complete.');
  }

  void _showAddListDialog() {
    final TextEditingController _textController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New List'),
          content: TextField(
            controller: _textController,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter list name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  _addNewList(_textController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
        backgroundColor: Colors.green,
        actions: [
          Switch(
            value: themeManager.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeManager.toggleTheme(value);
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: _lists.keys.length,
        itemBuilder: (context, index) {
          String listName = _lists.keys.elementAt(index);
          return ListCard(
            listName: listName,
            onOpen: () => _navigateToListScreen(listName),
            onDelete: () => _deleteList(listName),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddListDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
