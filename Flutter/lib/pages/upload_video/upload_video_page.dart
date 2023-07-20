import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:orbital_app/pages/upload_video/video_player_view.dart';
import 'package:orbital_app/pages/upload_video/select_video.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:orbital_app/components/video_object.dart';
import 'package:orbital_app/components/analysed_video_player.dart';
import 'package:path/path.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'dart:convert';

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({super.key});

  @override
  State<UploadVideoPage> createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  File? _selectedVideo;
  String? message;
  bool showUploadButton = true;
  bool _isUploading = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _handleVideoUpload(File videoFile) {
    setState(() {
      _selectedVideo = videoFile;
    });
  }

  /*void resetPage() {
    setState(() {
      // Reset the variables to their initial values
      _selectedVideo = null;
      message = '';
      _isUploading = false;
      showSelectButton = true;
      showUploadButton = true;
      _titleController.clear();
      _descriptionController.clear();
    });
    SelectVideo(
      onVideoSelected: _handleVideoUpload,
      showSelectButton: showSelectButton,
    );
  }

  Widget _buildVideoSelectionWidget() {
    if (_selectedVideo == null) {
      setState(() {
        showSelectButton = true;
      });
      return SelectVideo(
        onVideoSelected: _handleVideoUpload,
        showSelectButton: showSelectButton,
      );
    } else {
      setState(() {
        showSelectButton = false;
      });
      return SelectVideo(
        onVideoSelected: _handleVideoUpload,
        showSelectButton: showSelectButton,
      );
    }
  }
  */

  void uploadVideoToFirestore(VideoObject video) async {
    try {
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(currentUser.email)
          .collection('videos')
          .add({
        'title': video.title,
        'description': video.description,
        'url': video.url,
      });
      print('Video uploaded to Firestore successfully');
    } catch (e) {
      print('Error uploading video to Firestore: $e');
    }
  }

  void _UploadVideoToServer(BuildContext context) async {
    if (_selectedVideo == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Video Not Selected'),
            content: Text('Please select a video before uploading.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Exit the method
    }
    setState(() {
      _isUploading = true;
    });
    String title = _titleController.text;
    String description = _descriptionController.text;
    var stream = _selectedVideo!.readAsBytes().asStream();
    var length = await _selectedVideo?.length();

    //need to change during deployment, ngrok link
    var uri = Uri.parse('https://1576-220-255-61-133.ngrok.io/upload');
    var request = http.MultipartRequest("POST", uri);
    final headers = {"Content-type": "multipart/form-data"};
    var multipartFile = http.MultipartFile(
      'video',
      stream,
      length!,
      filename: basename(_selectedVideo!.path),
    );
    request.files.add(multipartFile);
    //should make into an object
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = json.decode(res.body);
    message = resJson['message'];

    VideoObject video = VideoObject(
      title: title,
      description: description,
      url: resJson['cloudinary_url'],
    );
    print(video.url);
    setState(() {
      _isUploading = false;
    });
    if (message == 'Video Uploaded Successfully') {
      setState(() {
        showUploadButton = false;
      });
      // Hide the upload button when the video upload is successful
      uploadVideoToFirestore(video);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysedVideoPlayerPage(
              videoUrl: video.url,
              onGoBack: () {
                // Callback function to go back
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }),
        ),
      );
    } else {
      // Show the upload button when the video upload fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Video Upload Failed'),
            content: Text('Please try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Exit the method
    }

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
        backgroundColor: Color.fromARGB(255, 66, 162, 240),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 16.0),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignLabelWithHint: true,
              filled: true,
              fillColor: Colors
                  .white, // Example color, you can choose your desired color
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 30.0),
          SelectVideo(
            onVideoSelected: _handleVideoUpload,
          ),
          const SizedBox(height: 10.0),
          Stack(
            children: [
              Visibility(
                visible: !_isUploading && showUploadButton,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity, //parent's width
                        child: TextButton(
                          onPressed: () {
                            _UploadVideoToServer(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, // Button text color
                            backgroundColor: Color.fromARGB(
                                255, 66, 162, 240), // Button background color
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ), // Button padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Button border radius
                            ),
                          ),
                          child: const Text('Upload Video'),
                        ),
                      ),
                      const SizedBox(
                          height:
                              16.0), // Add spacing between the button and the message
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _isUploading,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Sorry, it might take a while...',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            // Show the message conditionally
            visible: message != null,
            child: Text(
              message ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed:
            resetPage, // Call the resetPage function when the button is pressed
        child: Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, */
    );
  }
}
