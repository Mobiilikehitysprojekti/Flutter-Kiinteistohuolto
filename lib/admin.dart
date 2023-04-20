import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Admin {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? user;
  static late String uid;
  static final CollectionReference adminCollection =
  FirebaseFirestore.instance.collection('Admin');
  static late QuerySnapshot adminSnapshot;

      static Future<void> isAdmin() async {
        user = _auth.currentUser;
        uid = user!.uid;
        adminSnapshot = await adminCollection.where('UID', isEqualTo: uid).get();
      }

      static bool admin() {
        if (adminSnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
      }

      
}