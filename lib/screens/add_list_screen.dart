import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddListScreen extends StatefulWidget {
  @override
  _AddListScreenState createState() => _AddListScreenState();
}

class _AddListScreenState extends State<AddListScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  List<Map<String, dynamic>> _groceryItems = [];
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;

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

  void _showOverlayNotification(String message, Color backgroundColor) {
    if (_isOverlayVisible) {
      _overlayEntry?.remove();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Add padding to avoid status bar
        left: 10,
        right: 10,
        child: Material(
          color: backgroundColor,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
    _isOverlayVisible = true;

    Future.delayed(Duration(seconds: 2), () {
      if (_isOverlayVisible) {
        _overlayEntry?.remove();
        _isOverlayVisible = false;
      }
    });
  }

  void _addItem(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('groceryItems') ?? [];
    final newItem = '${_textController.text}|false';

    if (_textController.text.isNotEmpty && !items!.contains(newItem)) {
      items.add(newItem);
      prefs.setStringList('groceryItems', items);
      setState(() {
        _groceryItems = items.map((item) {
          final parts = item.split('|');
          return {
            'name': parts[0],
            'isChecked': false,
          };
        }).toList();
      });
      _textController.clear();
      FocusScope.of(context).requestFocus(_textFocusNode); // Keep the keyboard open and focus on input field
      _showOverlayNotification('Item added!', Colors.green);
    } else {
      _showOverlayNotification('Item already exists or is empty!', Colors.redAccent);
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
        title: Text('Add List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              focusNode: _textFocusNode, // Set the focus node
              decoration: InputDecoration(
                labelText: 'Enter grocery item',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onEditingComplete: () => _addItem(context), // Handle Done key
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _addItem(context),
              child: Text('Add Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}
