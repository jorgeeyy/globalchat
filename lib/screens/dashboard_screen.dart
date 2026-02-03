import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:globalchat/screens/profile_screen.dart';
import 'package:globalchat/screens/splash_screen.dart';
import 'package:provider/provider.dart' show Provider;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> chatroomsList = [];

  void getChatrooms() {
    db.collection('chatrooms').get().then((dataSnapshot) {
      chatroomsList.clear();
      for (var singleChatroomData in dataSnapshot.docs) {
        chatroomsList.add(singleChatroomData.data());
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getChatrooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Global Chat'),
        leading: InkWell(
          onTap: () => scaffoldKey.currentState!.openDrawer(),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              radius: 20,
              child: Text(
                userProvider.userName.isNotEmpty
                    ? userProvider.userName[0].toUpperCase()
                    : '',
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 50),
            ListTile(
              leading: CircleAvatar(
                child: Text(
                  userProvider.userName.isNotEmpty
                      ? userProvider.userName[0].toUpperCase()
                      : '',
                ),
              ),
              title: Text(
                userProvider.userName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(userProvider.userEmail),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Profile'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: chatroomsList.length,
        itemBuilder: (BuildContext context, int index) {
          String chatroomName = chatroomsList[index]["chatroom_name"] ?? '';
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
              child: Text(chatroomName[0].toUpperCase()),
            ),
            title: Text(chatroomName),
            subtitle: Text(chatroomsList[index]["desc"] ?? 'no description'),
          );
        },
      ),
    );
  }
}
