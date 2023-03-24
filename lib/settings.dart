import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kiinteistohuolto/signIn.dart';

void main() => runApp(const Settings());

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  static const String _title = 'Settings';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(children: <Widget>[
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
          onPressed: () => FirebaseAuth.instance.signOut(),
        ),
      ]),
    );
  }
}
