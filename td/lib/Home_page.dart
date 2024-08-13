import 'package:flutter/material.dart';
import 'package:td/db_service.dart';

class HomePage extends StatefulWidget {
  
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _malumotController = TextEditingController();
  DbService dbService = DbService();

  @override
  void initState() {
    super.initState();
    dbService.openBox();
  }


  void _showEditDialog(BuildContext context, int index, String currentData) {
    TextEditingController _editController = TextEditingController(text: currentData);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ma'lumotni tahrirlash"),
        content: TextFormField(
          controller: _editController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Bekor qilish"),
          ),
          TextButton(
            onPressed: () async {
              await dbService.updateItem(index, _editController.text);
              setState(() {});
              Navigator.pop(context);
            },
            child: Text("Saqlash"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 100,
              width: 300,
              child: TextFormField(
                controller: _malumotController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: FutureBuilder(
              future: dbService.getTodos(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data is String) {
                  return Center(
                    child: Text(snapshot.data),
                  );
                } else {
                  return ListView.builder(
                    itemCount: (snapshot.data as List).length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index].toString()),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                  "${(snapshot.data as List)[index]} - Nima qilishni xohlaysiz?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Bekor qilish"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await dbService.deleteItems(index);
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Text("O'chirish"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showEditDialog(context, index, snapshot.data[index].toString());
                                  },
                                  child: Text("Tahrirlash"),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await dbService.writeToDB(_malumotController.text);
          _malumotController.clear();
          setState(() {});
        },
        label: Text("Saqlash"),
      ),
    );
  }
}
