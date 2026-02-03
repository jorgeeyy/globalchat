import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String userName = '';
  String userEmail = '';
  String userId = '';
  Map<String, dynamic>? userData = {};

  var db = FirebaseFirestore.instance;

  void getUserDetails() async {
    var authUser = FirebaseAuth.instance.currentUser;
    db.collection('users').doc(authUser!.uid).get().then((datasnapshot) {
      // userData = datasnapshot.data();
      userName = datasnapshot.data()?["name"] ?? '';
      userEmail = datasnapshot.data()?["email"] ?? '';
      userId = datasnapshot.data()?["id"] ?? '';
      notifyListeners();
      // setState(() {});
    });
  }
}
