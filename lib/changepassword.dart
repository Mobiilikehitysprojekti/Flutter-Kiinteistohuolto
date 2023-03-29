import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'navBar.dart';


class ChangePW extends StatelessWidget {
  final TextEditingController _newPasswordController = TextEditingController();
  TextEditingController pwagainController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Change Password',
                style: TextStyle(
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