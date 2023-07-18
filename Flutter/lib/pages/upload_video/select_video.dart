import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:orbital_app/pages/upload_video/video_player_view.dart';

class SelectVideo extends StatefulWidget {
  const SelectVideo({
    super.key,
    required this.onVideoSelected,
  });

  final void Function(File videoFile) onVideoSelected;

  @override
  State<SelectVideo> createState() => _SelectVideoState();
}

class _SelectVideoState extends State<SelectVideo> {
  File? _file;
  bool _isVideoPlaying = false;

  void _handleVideoSelected(File videoFile) {
    setState(() {
      _file = videoFile;
      _isVideoPlaying = false;
    });

    // Pass the selected video file back to the UploadVideoPage
    widget.onVideoSelected(videoFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_file != null)
          VideoPlayerView(
            url: _file!.path,
            dataSourceType: DataSourceType.file,
            onVideoStart: () {
              setState(() {
                _isVideoPlaying = true;
              });
            },
          ),
        if (_file == null || !_isVideoPlaying)
          TextButton(
            onPressed: () async {
              final file =
                  await ImagePicker().pickVideo(source: ImageSource.gallery);
              if (file != null) {
                _handleVideoSelected(File(file.path));
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, // Button text color
              backgroundColor: Colors.blue, // Button background color
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10), // Button padding
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)), // Button shape
            ),
            child: const Text(
              'Select Video',
            ),
          ),
      ],
    );
  }
}
