import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ListManager extends ChangeNotifier {
  Map<String, List<Map<String, dynamic>>> _lists = {};

  Map<String, List<Map<String, dynamic>>> get lists => _lists;

  ListManager() {
    _loadLists();
  }

  Future<void> _loadLists() async {
    final prefs = await SharedPreferences.getInstance();
    final String? listsString = prefs.getString('lists');
    if (listsString != null) {
      _lists = Map<String, List<Map<String, dynamic>>>.from(
        jsonDecode(listsString).map((key, value) => MapEntry(key, List<Map<String, dynamic>>.from(value))),
      );
      notifyListeners();
    }
  }

  Future<void> _saveLists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lists', jsonEncode(_lists));
  }

  void addList(String listName) {
    _lists[listName] = [];
    _saveLists();
    notifyListeners();
  }

  void removeList(String listName) {
    _lists.remove(listName);
    _saveLists();
    notifyListeners();
  }

  void updateList(String listName, List<Map<String, dynamic>> items) {
    _lists[listName] = items;
    _saveLists();
    notifyListeners();
  }
}
