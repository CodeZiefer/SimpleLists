import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_lists/utils/theme_manager.dart'; // Updated import
import 'package:simple_lists/utils/list_manager.dart'; // Updated import
import 'package:simple_lists/screens/list_screen.dart'; // Updated import
import 'package:simple_lists/widgets/list_card.dart'; // Updated import

class CoverScreen extends StatefulWidget {
  @override
  _CoverScreenState createState() => _CoverScreenState();
}

class _CoverScreenState extends State<CoverScreen> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final listManager = Provider.of<ListManager>(context);

    final appBarColor = themeManager.themeMode == ThemeMode.dark
        ? Colors.lightBlue
        : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
        backgroundColor: appBarColor,
        actions: [
          TextButton(
            onPressed: () {
              _showAddListDialog(context, listManager);
            },
            child: Text('Add List', style: TextStyle(color: Colors.white)),
          ),
          Switch(
            activeColor: Colors.white,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
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
        itemCount: listManager.lists.keys.length,
        itemBuilder: (context, index) {
          String listName = listManager.lists.keys.elementAt(index);
          return ListCard(
            listName: listName,
            onOpen: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListScreen(
                    listName: listName,
                    items: listManager.lists[listName]!,
                    onSave: (items) {
                      listManager.updateList(listName, items);
                    },
                  ),
                ),
              );
            },
            onDelete: () => listManager.removeList(listName),
          );
        },
      ),
    );
  }

  void _showAddListDialog(BuildContext context, ListManager listManager) {
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
                  listManager.addList(_textController.text);
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
}
