import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatelessWidget {
  OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference orders =
        FirebaseFirestore.instance.collection('Orders');
    var lista = [];
    return Scaffold(
      body: StreamBuilder(
          stream: orders.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
              if (streamSnapshot.data?.docs[i]['UID'] ==
                  FirebaseAuth.instance.currentUser?.uid) {
                lista.add(streamSnapshot.data?.docs[i]);
              }
            }
            if (lista.isNotEmpty) {
              return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.network(lista[index]['image'],
                              fit: BoxFit.cover,
                              height: 150,
                              width: MediaQuery.of(context).size.width),
                          ListTile(
                            title: Text(lista[index]['service']),
                            subtitle:
                                Text(DateFormat('MMM d, yyyy h:mm a').format(
                              (lista[index]['timestamp'] as Timestamp).toDate(),
                            )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('About'),
                                onPressed: () {
                                  _displayTextInputDialog(context);
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            } else if (lista.isEmpty) {
              return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text('No orders yet...'),
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  final TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Input email"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Delete user'),
                onPressed: () {
                  Navigator.pop(context);
                  String? email = FirebaseAuth.instance.currentUser!.email;
                  if (_textFieldController.text != email) {
                    Fluttertoast.showToast(msg: "Wrong Email!");
                  } else {
                    FirebaseAuth.instance.currentUser!.delete();
                  }
                },
              ),
            ],
          );
        });
  }
}

class About extends StatelessWidget {
  static late DocumentSnapshot documentSnapshot;
  About(DocumentSnapshot snapshot, {super.key}) {
    documentSnapshot = snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(documentSnapshot['service'])),
      body:
          Center(child: Column(children: [Text(documentSnapshot['message'])])),
    );
  }

  
}
