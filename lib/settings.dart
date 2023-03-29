import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kiinteistohuolto/theme_constants.dart';
import 'package:flutter_kiinteistohuolto/theme_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './signIn.dart';


ThemeManager _themeManager = ThemeManager();

class Settings extends StatefulWidget {
  @override
  _MySettings createState() => _MySettings();

  getThememode() {
    return _themeManager;
  }
}

 

class _MySettings extends State<Settings> {
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
  final TextEditingController _newPasswordController = TextEditingController();
  TextEditingController pwagainController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          Switch(
              value: _themeManager.themeMode == ThemeMode.dark,
              onChanged: (newValue) {
                _themeManager.toggleTheme(newValue);
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              child: Text(
                'Change Password',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              )),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: _newPasswordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: TextField(
              obscureText: true,
              controller: pwagainController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Retype password',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ElevatedButton(
              child: const Text('Change Password'),
              onPressed: () {
                changePassword(_newPasswordController.text);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: ElevatedButton(
              child: const Text('Sign out'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Signin()));
              },
            ),
          ),
        ]),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> changePassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (_newPasswordController.text != pwagainController.text.trim()) {
      Fluttertoast.showToast(msg: "Passwords do not match");
    } else {
      if (user != null) {
        await user.updatePassword(newPassword).then((_) {
          Fluttertoast.showToast(msg: "Password changed successfully");
          print("Password changed successfully");
        }).catchError((error) {
          print("Password not changed: $error");
        });
      }
    }
  }
}
