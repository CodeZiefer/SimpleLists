import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_lists/utils/theme_manager.dart'; // Updated import
import 'package:simple_lists/widgets/grocery_item_card.dart'; // Updated import

class ListScreen extends StatefulWidget {
  final String listName;
  final List<Map<String, dynamic>> items;
  final ValueChanged<List<Map<String, dynamic>>> onSave;

  const ListScreen({
    required this.listName,
    required this.items,
    required this.onSave,
  });

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late List<Map<String, dynamic>> _items;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final mediaQuery = MediaQuery.of(context);
    final aspectRatio = mediaQuery.size.width / mediaQuery.size.height;
    final isMainMenu = aspectRatio >= 1.0; // Corrected logic to detect main screen mode

    final appBarColor = themeManager.themeMode == ThemeMode.dark
        ? Colors.lightBlue
        : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName),
        backgroundColor: appBarColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                _showAddItemDialog(context);
              },
              child: Text(
                'Add Item',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  shadows: [
                    Shadow(
                      offset: Offset(-1.0, -1.0),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(1.0, -1.0),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(-1.0, 1.0),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
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
      body: isMainMenu
          ? GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 2.5, // Adjusted aspect ratio for better fit
              ),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return GroceryItemCard(
                  item: item['name'],
                  isChecked: item['isChecked'],
                  onToggle: () {
                    setState(() {
                      _items[index]['isChecked'] = !_items[index]['isChecked'];
                    });
                    widget.onSave(_items);
                  },
                  onDelete: () {
                    setState(() {
                      _items.removeAt(index);
                    });
                    widget.onSave(_items);
                  },
                );
              },
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return GroceryItemCard(
                  item: item['name'],
                  isChecked: item['isChecked'],
                  onToggle: () {
                    setState(() {
                      _items[index]['isChecked'] = !_items[index]['isChecked'];
                    });
                    widget.onSave(_items);
                  },
                  onDelete: () {
                    setState(() {
                      _items.removeAt(index);
                    });
                    widget.onSave(_items);
                  },
                );
              },
            ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: TextField(
            controller: _textController,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter item name'),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                _addItem(value);
                _textController.clear();
                _refocusTextField();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  _addItem(_textController.text);
                  _textController.clear();
                  _refocusTextField();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addItem(String itemName) {
    setState(() {
      _items.add({'name': itemName, 'isChecked': false});
    });
    widget.onSave(_items);
  }

  void _refocusTextField() {
    Navigator.of(context).pop();
    Future.delayed(Duration.zero, () {
      _showAddItemDialog(context);
    });
  }
}
