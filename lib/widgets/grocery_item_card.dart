import 'package:flutter/material.dart';

class GroceryItemCard extends StatefulWidget {
  final String item;
  final bool isChecked;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const GroceryItemCard({
    required this.item,
    required this.isChecked,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  _GroceryItemCardState createState() => _GroceryItemCardState();
}

class _GroceryItemCardState extends State<GroceryItemCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Color _cardColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${widget.item}"?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _cardColor = Colors.transparent;
              });
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onDelete();
              setState(() {
                _cardColor = Colors.transparent; // Reset color immediately upon deletion
              });
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _cardColor = Colors.redAccent;
        });
        _controller.forward().then((_) {
          Future.delayed(Duration(milliseconds: 300)).then((_) {
            _controller.reverse().then((_) {
              _showDeleteDialog();
            });
          });
        });
      },
      onTap: widget.onToggle,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          color: _cardColor == Colors.transparent 
                ? (widget.isChecked 
                      ? (Theme.of(context).brightness == Brightness.dark ? Colors.grey[700] : Colors.green[100]) 
                      : Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Theme.of(context).cardColor) 
                : _cardColor,
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            title: Text(
              widget.item,
              style: TextStyle(
                decoration: widget.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                fontSize: 16.0,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
            trailing: Icon(
              widget.isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              color: widget.isChecked ? Theme.of(context).checkboxTheme.fillColor?.resolve({MaterialState.selected}) : null,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
