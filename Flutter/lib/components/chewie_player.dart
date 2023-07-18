import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewiePlayer extends StatefulWidget {
  final String videoUrl;

  ChewiePlayer({required this.videoUrl});

  @override
  _ChewiePlayerState createState() => _ChewiePlayerState();
}

class _ChewiePlayerState extends State<ChewiePlayer> {
  late ChewieController _chewieController;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    final videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    //await videoPlayerController.initialize();
    final videoSize = await _getVideoSize(videoPlayerController);
    final aspectRatio = videoSize != null
        ? videoSize.width / videoSize.height
        : 16 / 9; // Set a default aspect ratio if video size is not available

    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: aspectRatio,
        autoPlay: true,
        looping: true,
      );
      _isInitializing = false;
    });
  }

  Future<Size> _getVideoSize(VideoPlayerController controller) async {
    await controller.initialize();
    final videoSize = controller.value.size;
    return videoSize;
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Chewie(
      controller: _chewieController,
    );
  }
}
