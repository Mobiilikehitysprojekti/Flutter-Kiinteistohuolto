import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'navBar.dart';
import 'package:intl/intl.dart';


class News extends StatefulWidget {
  const News({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  int _cardCount = 3;
  bool isAdmin = true;
  bool isEditing = false;
  String? selectedCardId;
  TextEditingController _titleEditingController =
      TextEditingController(text: '');
  TextEditingController _descriptionEditingController =
      TextEditingController(text: '');

  final CollectionReference _services =
      FirebaseFirestore.instance.collection('News');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("news"),
        actions: [
          if (isAdmin)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _addCard,
            ),
        ],
      ),
      body: StreamBuilder(
        stream: _services.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                final bool isSelected = documentSnapshot.id == selectedCardId;
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (isSelected && isEditing)
                        Column(
                          children: [
                            TextFormField(
                              controller: _titleEditingController,
                              decoration: InputDecoration(
                                hintText: 'Enter title',
                              ),
                            ),
                            TextFormField(
                              controller: _descriptionEditingController,
                              decoration: InputDecoration(
                                hintText: 'Enter description',
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    setState(() {
                                      isEditing = false;
                                      selectedCardId = null;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  child: const Text('Save'),
                                  onPressed: () {
                                    final newTitle =
                                        _titleEditingController.text;
                                    final newDescription =
                                        _descriptionEditingController.text;
                                    _services.doc(documentSnapshot.id).update({
                                      'title': newTitle,
                                      'description': newDescription
                                    }).then((value) => setState(() {
                                          isEditing = false;
                                          selectedCardId = null;
                                        }));
                                  },
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        )
                      else
                        ListTile(
                          title: Text(documentSnapshot['title']),
                          subtitle: Text(documentSnapshot['description']),
                          trailing: Text(
                            DateFormat('MMM d, yyyy h:mm a').format(
                              (documentSnapshot['timestamp'] as Timestamp)
                                  .toDate(),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          if (isAdmin)
                            TextButton(
                              child: const Text('edit'),
                              onPressed: () {
                                setState(() {
                                  isEditing = true;
                                  selectedCardId = documentSnapshot.id;
                                  _titleEditingController.text =
                                      documentSnapshot['title'];
                                  _descriptionEditingController.text =
                                      documentSnapshot['description'];
                                });
                              },
                            ),
                          const SizedBox(width: 8),
                          if (isAdmin)
                            TextButton(
                              child: const Text('delete'),
                              onPressed: () {
                                _services.doc(documentSnapshot.id).delete();
                              },
                            ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Card(child: Text("No services available"));
          }
        },
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  void _addCard() {
    _services.add({
      'title': 'New card title',
      'description': 'New card description',
      'timestamp': Timestamp.now(),
    });
  }
}
