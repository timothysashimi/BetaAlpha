import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:orbital_app/pages/upload_video/video_player_view.dart';
import 'package:orbital_app/components/video_data_server.dart';
import 'package:orbital_app/pages/upload_video/select_video.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

currentUser() {
  final user = FirebaseAuth.instance.currentUser;
  return user!.uid;
}

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({super.key});

  @override
  State<UploadVideoPage> createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  File? _selectedVideo;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _handleVideoUpload(File videoFile) {
    setState(() {
      _selectedVideo = videoFile;
    });
  }

  void _UploadVideoToServer() async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    var stream = http.ByteStream(Stream.castFrom(_selectedVideo!.openRead()));
    var length = await _selectedVideo?.length();
    var uri = Uri.parse('http://0.0.0.0:5000/analyse');
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length!,
      filename: basename(_selectedVideo!.path),
    );
    request.files.add(multipartFile);
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['userID'] = currentUser();
    var response = await request.send();

    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedVideo = null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Analysis'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 16.0),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16.0),
          SelectVideo(onVideoSelected: _handleVideoUpload),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Implement video upload logic
              _UploadVideoToServer;
            },
            child: const Text('Upload Video'),
          ),
        ],
      ),
    );
  }
}
