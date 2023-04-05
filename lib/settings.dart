import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kiinteistohuolto/theme_constants.dart';
import 'package:flutter_kiinteistohuolto/theme_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './signIn.dart';
import './changepassword.dart';
import 'navBar.dart';

ThemeManager _themeManager = ThemeManager();
var mode = "on";

class SettingsClass extends StatefulWidget {
  @override
  _MySettings createState() => _MySettings();

  getThememode() {
    return _themeManager;
  }
}

class _MySettings extends State<SettingsClass> {
  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeManager.themeMode,
        home: SettingsPage(),
      );
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: SwitchListTile(
                title: Text("Turn " + mode + " dark mode"),
                value: _themeManager.themeMode == ThemeMode.dark,
                onChanged: (newValue) {
                  _themeManager.toggleTheme(newValue);
                  if (newValue == false) {
                    mode = "on";
                  }
                  if (newValue == true) {
                    mode = "off";
                  }
                }),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: SizedBox(
              width: 200,
              height: 30,
              child: ElevatedButton.icon(
                label: const Text('Change Password'),
                icon: const Icon(Icons.password),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChangePW()));
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: SizedBox(
                width: 200,
                height: 30,
                child: ElevatedButton.icon(
                  label: const Text('Sign out'),
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Signin()));
                  },
                )),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: SizedBox(
              width: 200,
              height: 30,
              child: ElevatedButton.icon(
                label: const Text('Delete User'),
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _displayTextInputDialog(context);
                },
              ),
            ),
          ),
        ]),
      ),
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
