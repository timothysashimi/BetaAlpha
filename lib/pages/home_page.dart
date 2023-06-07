import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbital_app/pages/upload_video/upload_video_page.dart';
import 'package:orbital_app/pages/profile/profile_page.dart';
import 'package:orbital_app/pages/calendar.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override //Abstract Method
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
      ]),
      body: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [ 
                IconButton(
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed: () {
                    // Navigate to home page
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => CalendarScreen()));
                  },
                ),
                Text("LOGGED IN AS: ${user.email!}",)
              ]
          ), 
        ),
      
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 56.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // Navigate to home page
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.cloud_upload),
                onPressed: () {
                  // Navigate to upload video page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => UploadVideoPage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  // Navigate to profile page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ProfilePage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
