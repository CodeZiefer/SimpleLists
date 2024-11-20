import 'package:flutter/material.dart';

class ListCard extends StatefulWidget {
  final String listName;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  const ListCard({
    required this.listName,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> with SingleTickerProviderStateMixin {
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
        content: Text('Are you sure you want to delete the "${widget.listName}" list?'),
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
      onTap: widget.onOpen,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          color: _cardColor == Colors.transparent
              ? (Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Theme.of(context).cardColor)
              : _cardColor,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              widget.listName,
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
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
