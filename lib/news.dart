import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'navBar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  bool isEditing = false;
  bool admin = Admin.admin();
  String? selectedCardId;
  final TextEditingController _titleEditingController =
      TextEditingController(text: '');
  final TextEditingController _descriptionEditingController =
      TextEditingController(text: '');

  final CollectionReference _services =
      FirebaseFirestore.instance.collection('News');


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      floatingActionButton: admin
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: _addCard,
            )
          : null,
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
                bool isExpanded = false;

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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedCardId == documentSnapshot.id
                                    ? documentSnapshot['description']
                                    : documentSnapshot['description'].length >
                                            200
                                        ? '${documentSnapshot['description'].substring(0, 200)}...'
                                        : documentSnapshot['description'],
                              ),
                            ],
                          ),
                          trailing: Text(
                            DateFormat('MMM d, yyyy h:mm a').format(
                              (documentSnapshot['timestamp'] as Timestamp)
                                  .toDate(),
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(documentSnapshot['title']),
                                content: Text(documentSnapshot['description']),
                                actions: [
                                  TextButton(
                                    child: const Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          if (admin && !isEditing)
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
                          if (admin && !isEditing)
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