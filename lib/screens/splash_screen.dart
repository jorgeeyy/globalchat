import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:globalchat/screens/dashboard_screen.dart';
import 'package:globalchat/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user = FirebaseAuth.instance.currentUser;

  void openDashboard() {
    Provider.of<UserProvider>(context, listen: false).getUserDetails();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
    );
  }

  void openLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (user == null) {
        openLogin();
      } else {
        openDashboard();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
