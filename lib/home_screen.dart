import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding and decoding

import 'package:todoapp/Utilities/header_widget.dart';
import 'package:todoapp/Utilities/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedItems = prefs.getString('todo_items');

    if (savedItems != null) {
      List<dynamic> decodedItems = json.decode(savedItems);
      setState(() {
        items = List<Map<String, dynamic>>.from(decodedItems);
      });
    }
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedItems = json.encode(items);
    await prefs.setString('todo_items', encodedItems);
  }

  void _showAddItemDialog() {
    String newItemText = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Item"),
          content: TextField(
            onChanged: (value) {
              newItemText = value;
            },
            decoration: const InputDecoration(hintText: "Enter item name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (newItemText.isNotEmpty) {
                    items.add({'text': newItemText, 'isChecked': false});
                    _saveTasks(); // Save tasks after adding
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      _saveTasks(); // Save tasks after deleting
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.blue,
          child: Column(
            children: [
              HeaderWidget(taskCount: items.length),
              Expanded(
                child: TaskList(
                  items: items,
                  onToggleCheckbox: (index, value) {
                    setState(() {
                      items[index]['isChecked'] = value!;
                      _saveTasks(); // Save tasks after toggling
                    });
                  },
                  onDeleteItem: _deleteItem, // Pass delete function
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddItemDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
