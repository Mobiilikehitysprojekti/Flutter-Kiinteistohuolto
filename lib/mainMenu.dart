import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'navBar.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final CollectionReference services =
        FirebaseFirestore.instance.collection('Services');
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: StreamBuilder(
          stream: services.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.network(documentSnapshot['image'],
                              fit: BoxFit.cover,
                              height: 200,
                              width: MediaQuery.of(context).size.width),
                          ListTile(
                              title: Text(documentSnapshot['name']),
                              subtitle: Text("${documentSnapshot['price']} €")),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('About'),
                                onPressed: () {/* ... */},
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('Order'),
                                onPressed: () {/* ... */},
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return const Card(child: Text("No services available"));
            }
          }),
      bottomNavigationBar: const NavBar(),
    );
  }
}
