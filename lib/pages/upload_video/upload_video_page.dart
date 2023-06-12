import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:orbital_app/pages/upload_video/video_player_view.dart';
import 'package:orbital_app/components/video_data.dart';
import 'package:orbital_app/pages/upload_video/select_video.dart';

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

  void _UploadVideoLogic() {
    String title = _titleController.text;
    String description = _descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty && _selectedVideo != null) {
      // Implement video upload logic using _selectedVideo
      // For example, you can upload the video to a server or store it locally
      // You can access the file path using _selectedVideo.path
      VideoData videoData = VideoData(
        title: title,
        description: description,
        videoFile: _selectedVideo!,
      );

      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedVideo = null;
      });
    } else {
      // Handle case where required fields are not filled or video is not selected
      // Display an error message or show a snackbar to notify the user
    }
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
            },
            child: const Text('Analyse Video'),
          ),
          const SizedBox(height: 4.0),
          ElevatedButton(
            onPressed: () {
              // Implement video upload logic
            },
            child: const Text('Upload Video'),
          ),
        ],
      ),
    );
  }
}
