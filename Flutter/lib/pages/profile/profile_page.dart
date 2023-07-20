import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orbital_app/components/text_box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  //all users
  final usersCollection = FirebaseFirestore.instance.collection("userProfile");
  final double coverHeight = 280;
  final double profileHeight = 144;

  //edit field
  Future<void> editField(String field) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //cancel button
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          //save button
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          )
        ],
      ),
    );

    //update Firestore
    if (newValue.trim().length > 0) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.asset('assets/janja.jpeg',
            width: double.infinity, height: coverHeight, fit: BoxFit.cover),
      );

  Widget buildProfileImage() => ProfilePicture(
        name: currentUser.email!.split('@')[0],
        radius: MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
                .size
                .width /
            6,
        fontsize: 30,
        random: true,
      );

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          buildCoverImage(),
          Positioned(
            top: top,
            child: buildProfileImage(),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Color.fromARGB(255, 66, 162, 240),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("userProfile")
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              try {
                if (snapshot.hasData && snapshot.data != null) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return ListView(children: [
                    buildTop(),
                    const SizedBox(height: 80),
                    Text(
                      currentUser.email!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'My Details',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    //username
                    MyTextBox(
                        text: userData['username'],
                        sectionName: 'Username',
                        onPressed: () => editField('username')),
                    //bio
                    MyTextBox(
                        text: userData['bio'],
                        sectionName: 'Bio',
                        onPressed: () => editField('bio')),
                    //goal
                    MyTextBox(
                        text: userData['goal'],
                        sectionName: 'Current Goal',
                        onPressed: () => editField('goal')),
                  ]);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } catch (error) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Error: $error',
                      style: TextStyle(color: Colors.red),
                      textAlign:
                          TextAlign.center, // Align the text to the center
                    ),
                  ),
                );
              }
            }));
  }
}
