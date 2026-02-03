import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String userName = '';
  String userEmail = '';
  String userId = '';
  Map<String, dynamic>? userData = {};

  var authUser = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;

  void getUserDetails() async {
    // Example function to fetch user profile data from Firestore
    db.collection('users').doc(authUser!.uid).get().then((datasnapshot) {
      // userData = datasnapshot.data();
      userName = datasnapshot.data()?["name"] ?? '';
      userEmail = datasnapshot.data()?["email"] ?? '';
      userId = datasnapshot.data()?["id"] ?? '';
      notifyListeners();
      // setState(() {});
    });
  }

  // String get username => _username;

  // void setUsername(String username) {
  //   _username = username;
  //   notifyListeners();
  // }
}
