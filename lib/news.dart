import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'navBar.dart';

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
        stream: _services.snapshots(),
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
                                    _services
                                        .doc(documentSnapshot.id)
                                        .update({
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
    });
  }
}




class MenuCard extends StatefulWidget {
  const MenuCard({Key? key, required this.isAdmin}) : super(key: key);
  final bool isAdmin;

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  bool isExpanded = false;
  bool isEditing = false;
  String _description = 'Description'; // variable to save user input
  TextEditingController _textEditingController =
      TextEditingController(text: 'Enter new desc');

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('News title'),
            subtitle: isEditing
                ? TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Enter a new description',
                    ),
                    onChanged: (value) {
                      _description = value; // save user input to variable
                    },
                  )
                : Text(_description), // display the saved user input
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('More details'),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: Text(
                  isEditing ? 'Save' : 'Edit',
                  style: TextStyle(
                    color: widget.isAdmin ? Colors.blue : Colors.grey,
                  ),
                ),
                onPressed: widget.isAdmin
                    ? () {
                        setState(() {
                          if (!isEditing) {
                            isEditing = true;
                          } else {
                            isEditing = false;
                          }
                        });
                      }
                    : null,
              ),
              SizedBox(width: 8),
              TextButton(
                child: Text(isExpanded ? 'Close' : 'Read more'),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
