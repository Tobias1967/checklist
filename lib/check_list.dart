import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkliste',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ListInputScreen(),
    );
  }
}

class ListInputScreen extends StatefulWidget {
  const ListInputScreen({super.key});

  @override
  _ListInputScreenState createState() => _ListInputScreenState();
}

class _ListInputScreenState extends State<ListInputScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedItems = prefs.getStringList('items');
    await Future.delayed(
        const Duration(seconds: 2)); // Simuliere eine Verzögerung
    setState(() {
      _items = storedItems ?? [];
      _isLoading = false;
    });
  }

  void _addItem() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _items.add(_controller.text);
        _controller.clear();
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('items', _items);
    }
  }

  void _deleteItem(int index) async {
    setState(() {
      _items.removeAt(index);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', _items);
  }

  void _editItem(int index) {
    _controller.text = _items[index];
    _deleteItem(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        ///////// Oberer Teil für Navigation, falls zweiter Screen...
        backgroundColor: const Color.fromARGB(255, 111, 182, 239),
        title: const Text(
          selectionColor: Color.fromARGB(255, 251, 250, 250),
          'Checkliste Shared Preferences', ///// Titel
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Texteingabe',
                      suffixIcon: IconButton(
                        onPressed: _controller.clear,
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Text hinzufügen'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_items[index]),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editItem(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteItem(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
