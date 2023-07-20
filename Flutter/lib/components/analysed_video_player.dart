import 'package:flutter/material.dart';
import './chewie_player.dart';

class AnalysedVideoPlayerPage extends StatelessWidget {
  final String videoUrl;
  final VoidCallback onGoBack;

  const AnalysedVideoPlayerPage(
      {super.key, required this.videoUrl, required this.onGoBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pose Estimation Video Player'),
        backgroundColor: Color.fromARGB(255, 66, 162, 240),
      ),
      body: Center(
        child: ChewiePlayer(videoUrl: videoUrl),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Invoke the callback function to go back
          onGoBack();
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
