/*
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:video_player/video_player.dart';

class Analyzer extends StatefulWidget {
  @override
  _MyAnalyzer createState() => _MyAnalyzer();
}

class _MyAnalyzer extends State<Analyzer> {
  late VideoPlayerController _videoController;
  final options = PoseDetectorOptions();
  final _poseDetector = PoseDetector(options: PoseDetectorOptions());
  List<Pose> _allPoses = [];

  @override
  void initState() {
    super.initState();
    _initializePoseDetector();
    _loadVideo();
  }

  Future<void> _initializePoseDetector() async {
    await _poseDetector.
  }

  Future<void> _loadVideo() async {
    _videoController = VideoPlayerController.asset('IMG_8079.MOV');
    await _videoController.initialize();
    setState(() {
      _videoController.play();
    });
    _processVideoFrames();
  }

  Future<void> _processVideoFrames() async {
    final Duration videoDuration = _videoController.value.duration;
    final frameCount = _videoController.value.
    final frameRate = frameCount / videoDuration.inSeconds;
    double currentTime = 0.0;
    while (currentTime < videoDuration.inSeconds) {
      _videoController.seekTo(Duration(seconds: currentTime.toInt()));
      await Future.delayed(Duration(milliseconds: (frameRate * 1000).round()));

      final image = await _videoController.texture.toImage();
      final inputImage = InputImage.fromImage(image);
      final poses = await _poseDetector.detectPoses(inputImage);

      setState(() {
        _allPoses.addAll(poses);
      });

      currentTime += frameRate;
    }
  }

  @override
  void dispose() {
    _poseDetector.close();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pose Estimation'),
        ),
        body: Column(
          children: [
            AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _allPoses.length,
                itemBuilder: (context, index) {
                  final pose = _allPoses[index];
                  final landmarks = pose.landmarks;

                  return ListTile(
                    title: Text('Pose $index'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pose Score: $poseScore'),
                        for (final landmark in landmarks)
                          Text('Landmark ${landmark.type}: (${landmark.x}, ${landmark.y})'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*

import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:video_player/video_player.dart';

final options = PoseDetectorOptions();
final poseDetector = PoseDetector(options: options);

*/