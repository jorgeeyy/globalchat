import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globalchat/screens/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupController {
  static Future<void> createAccount({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String country,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userId = FirebaseAuth.instance.currentUser!.uid;

      var db = FirebaseFirestore.instance;
      Map<String, dynamic> data = {
        'name': name,
        'country': country,
        'email': email,
        'id': userId.toString(),
      };
      try {
        await db.collection('users').doc(userId.toString()).set(data);
      } catch (e) {
        print('Error saving user data: $e');
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
        (route) => false,
      );
      print('account created successfully');
    } catch (e) {
      SnackBar messageSnackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(messageSnackbar);
      print(e);
    }
  }
}
