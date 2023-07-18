import 'package:flutter/material.dart';
import 'package:orbital_app/components/video_object.dart';
import './chewie_player.dart';

class GalleryVideoPlayerPage extends StatelessWidget {
  final VideoObject video;

  const GalleryVideoPlayerPage({Key? key, required this.video})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              video.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ChewiePlayer(videoUrl: video.url),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              video.description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
