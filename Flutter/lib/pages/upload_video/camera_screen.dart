import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:orbital_app/pages/google_mlkit/pose_dectector.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:developer' as devtools show log;


class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State <CameraScreen> createState() =>  CameraScreenState();
}

class  CameraScreenState extends State <CameraScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  late String videoPath;

  int direction = 0;

  @override
  void initState() {
    startCamera(direction);
    super.initState();
  }

  void startCamera(int direction) async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if(!mounted) {
        return;
      }
      setState(() {}); //To refresh widget
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> startRecordingVideo() async {
    if (!cameraController.value.isInitialized) {
      return;
    }

    // Create a directory to store the video
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);

    // Generate a unique filename for the video
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    videoPath = '$videoDirectory/$timestamp.mp4';

    // Start recording
    await cameraController.startVideoRecording();
  }

  Future<void> stopRecordingVideo() async { 

    if (!cameraController.value.isRecordingVideo) {
      return;
    }

    // Stop recording
    await cameraController.stopVideoRecording();

    devtools.log("1");

    // Save the video path
    setState(() {
      this.videoPath = videoPath;
    });

    devtools.log("2");

    // Save the video file
    final File videoFile = File(videoPath);

    devtools.log(videoPath);

    

    return;

  }

  @override
  Widget build(BuildContext context) {
    if(cameraController.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
        title: const Text('Camera'),
        ),
        body: Stack(
          children: [
            
            CameraPreview(cameraController),
              Row(
                children: [
                  GestureDetector(
                  onTap: () {
                    setState(() {
                      direction = direction == 0 ? 1 : 0;
                      startCamera(direction);
                    });
                  },
                  child: button(Icons.flip_camera_ios_outlined, Alignment.bottomLeft),
                  ),
                  GestureDetector(
                    onTap: () {
                      cameraController.takePicture().then((XFile? file) {
                        if(mounted) {
                          if(file != null) {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => PoseDetectorView(file: file)));
                            print("Picture saved to ${file.path}");
                          }
                        }
                      });
                    },
                    child: button(Icons.camera_alt_outlined, Alignment.bottomCenter),
                  ),
                  //take video 
                  GestureDetector(
                    onTap: () {
                      startRecordingVideo();
                      print("Video saved to ${this.videoPath}");
                    },
                    child: button(Icons.start, Alignment.bottomCenter),
                  ),
                  GestureDetector(
                    onTap: () {
                      stopRecordingVideo();
                    },
                    child: button(Icons.stop, Alignment.bottomCenter),
                  ),
                ],)
            ,
            const Align(
              alignment: AlignmentDirectional.topCenter,
              child: Text(
                "My Camera",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget button(IconData icon, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          bottom: 20,
        ),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

