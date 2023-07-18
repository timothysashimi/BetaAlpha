import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class VideoObject {
  final String title;
  final String description;
  final String url;

  VideoObject({
    required this.title,
    required this.description,
    required this.url,
  });

  factory VideoObject.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return VideoObject(
      title: data['title'],
      description: data['description'],
      url: data['url'],
    );
  }
}
