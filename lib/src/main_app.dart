import 'package:flutter/material.dart';

class DynamicListScreen extends StatefulWidget {
  const DynamicListScreen({super.key});

  @override
  _DynamicListScreenState createState() => _DynamicListScreenState();
}

class _DynamicListScreenState extends State<DynamicListScreen> {
  final DatabaseRepository dbRepository = DatabaseRepository();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamische Liste'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[900]!, Colors.blue[100]!],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Neuer Eintrag',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  setState(() {
                    dbRepository.addItem(textController.text);
                    textController.clear();
                  });
                }
              },
              child: const Text('Hinzufügen'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dbRepository.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dbRepository.items[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Eintrag bearbeiten'),
                                  content: TextField(
                                    controller: textController
                                      ..text = dbRepository.items[index],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Abbrechen'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          dbRepository.editItem(
                                              index, textController.text);
                                          textController.clear();
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('Speichern'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              dbRepository.deleteItem(index);
                            });
                          },
                        ),
                      ],
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

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
