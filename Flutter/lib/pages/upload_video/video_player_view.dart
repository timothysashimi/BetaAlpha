import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    required this.url,
    required this.dataSourceType,
    required this.onVideoStart,
  });

  final DataSourceType dataSourceType;
  final String url;
  final VoidCallback onVideoStart;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerView();
}

class _VideoPlayerView extends State<VideoPlayerView> {
  late VideoPlayerController _playerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _playerController = VideoPlayerController.file(File(widget.url));
    _playerController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _playerController,
          aspectRatio: _playerController.value.aspectRatio,
        );
        widget.onVideoStart(); // Call the callback function
      });
    });
  }

  @override
  void dispose() {
    _playerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _playerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _playerController.value.aspectRatio,
                child: Chewie(controller: _chewieController),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
