import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'KiinteistoApp',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              )),
          ElevatedButton(
              child: Text("Sign out"),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              }),
        ]),
      ),
    );
  }
}
