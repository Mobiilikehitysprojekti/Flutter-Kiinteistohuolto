import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference services =
        FirebaseFirestore.instance.collection('Services');
    return Scaffold(
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
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              About(documentSnapshot)));
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('Order'),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Order(documentSnapshot)));
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
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
}

class About extends StatelessWidget {
  static late DocumentSnapshot documentSnapshot;
  About(DocumentSnapshot snapshot, {super.key}) {
    documentSnapshot = snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(documentSnapshot['name'])),
      body: Center(child: Column(children: [Text(documentSnapshot['about'])])),
    );
  }
}

class Order extends StatefulWidget {
  static late DocumentSnapshot documentSnapshot;
  Order(DocumentSnapshot snapshot, {super.key}) {
    documentSnapshot = snapshot;
  }

  @override
  State<Order> createState() => _OrderFormState();
}

class _OrderFormState extends State<Order> {
  final textController = TextEditingController();
  DocumentSnapshot documentSnapshot = Order.documentSnapshot;

  CollectionReference orders = FirebaseFirestore.instance.collection('Orders');

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(documentSnapshot['name'])),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: Image.network(documentSnapshot['image'],
                  height: 250, width: 400, fit: BoxFit.cover),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: textController,
                decoration:
                    const InputDecoration(hintText: 'Additional message'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Price: ${documentSnapshot['price']}€"),
                ElevatedButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () {
                    addOrder();
                  },
                  child: const Text("Order"),
                )
              ],
            ),
          ],
        )));
  }

  Future<void> addOrder() {
    return orders
        .add({
          'service': documentSnapshot['name'],
          'status': false,
          'timestamp': DateTime.now(),
          'UID': FirebaseAuth.instance.currentUser!.uid,
          'message': textController.text
        })
        .then((value) => print("Data added"))
        .catchError((error) => print("Couldn't add order"));
  }
}
