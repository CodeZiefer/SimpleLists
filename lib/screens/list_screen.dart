import 'package:flutter/material.dart';
import '../widgets/grocery_item_card.dart';

class ListScreen extends StatefulWidget {
  final String listName;
  final List<Map<String, dynamic>> items;
  final Function(List<Map<String, dynamic>>) onSave;

  ListScreen({
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
  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _items = widget.items;
  }

  void _toggleItem(int index) {
    setState(() {
      _items[index]['isChecked'] = !_items[index]['isChecked'];
      widget.onSave(_items);
    });
  }

  void _addItem() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _items.add({'name': _textController.text, 'isChecked': false});
        widget.onSave(_items);
        _textController.clear();
        _textFocusNode.requestFocus();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      widget.onSave(_items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _textFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Add new item',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _addItem();
                    },
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return GroceryItemCard(
                  item: _items[index]['name'],
                  isChecked: _items[index]['isChecked'],
                  onToggle: () => _toggleItem(index),
                  onDelete: () => _removeItem(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
