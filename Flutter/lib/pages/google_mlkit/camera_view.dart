import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:developer' as devtools show log;
import 'package:orbital_app/pages/upload_video/video_player_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


class CameraView extends StatefulWidget {
  CameraView(
      {Key? key,
      required this.customPaint,
      required this.onImage,
      this.onCameraFeedReady,
      this.onDetectorViewModeChanged,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.back})
      : super(key: key);

  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final VoidCallback? onCameraFeedReady;
  final VoidCallback? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;


  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  bool _changingCameraLens = false;
  late String videoPath;
  bool _isVideoPlaying = false;


  @override
  void initState() {
    super.initState();

    _initialize();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  Future<void> startRecordingVideo() async {
    if (_controller != null) {
      if (!_controller!.value.isInitialized) {
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
      await _controller!.startVideoRecording();
      devtools.log("start");
    }
    return;
  }

  Future<void> stopRecordingVideo() async { 

    if (!_controller!.value.isRecordingVideo) {
      return;
    }

    // Stop recording
    await _controller!.stopVideoRecording();

    devtools.log("stop");

    // Save the video path
    setState(() {
      this.videoPath = videoPath;
      devtools.log("video path set");
    });

    

    // Save the video file
    final File videoFile = File(videoPath);

    VideoPlayerView(
            url: videoPath,
            dataSourceType: DataSourceType.file,
            onVideoStart: () {
              setState(() {
                _isVideoPlaying = true;
              });
            },
            
    );

    devtools.log(videoPath);

    

    return;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _liveFeedBody());
  }

  

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: _changingCameraLens
                ? const Center(
                    child: const Text('Changing camera lens'),
                  )
                : CameraPreview(
                    _controller!,
                    child: widget.customPaint,
                  ),
          ),
          _backButton(),
          _switchLiveCameraToggle(),
          _detectionViewModeToggle(),
          _zoomControl(),
          _exposureControl(),
          _startRecording(),
          _stopRecording(),
          instructions(),
        ],
      ),
    );
  }

  Widget instructions() => const Positioned(
    top: 40,
    left: 60,
    child: SizedBox(
      child: Text('Record your screen for review!',
        style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
        )
      ),
    )
  );

  Widget _backButton() => Positioned(
        top: 40,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: Colors.black54,
            child: const Icon(
              Icons.arrow_back_ios_outlined,
              size: 20,
            ),
          ),
        ),
      );

  Widget _detectionViewModeToggle() => Positioned(
        bottom: 8,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: widget.onDetectorViewModeChanged,
            backgroundColor: Colors.black54,
            child: const Icon(
              Icons.photo_library_outlined,
              size: 25,
            ),
          ),
        ),
      );

  Widget _switchLiveCameraToggle() => Positioned(
        bottom: 8,
        right: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: _switchLiveCamera,
            backgroundColor: Colors.black54,
            child: Icon(
              Platform.isIOS
                  ? Icons.flip_camera_ios_outlined
                  : Icons.flip_camera_android_outlined,
              size: 25,
            ),
          ),
        ),
      );

  Widget _zoomControl() => Positioned(
        bottom: 16,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Slider(
                    value: _currentZoomLevel,
                    min: _minAvailableZoom,
                    max: _maxAvailableZoom,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: (value) async {
                      setState(() {
                        _currentZoomLevel = value;
                      });
                      await _controller?.setZoomLevel(value);
                    },
                  ),
                ),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        '${_currentZoomLevel.toStringAsFixed(1)}x',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _exposureControl() => Positioned(
        top: 40,
        right: 8,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 250,
          ),
          child: Column(children: [
            Container(
              width: 55,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '${_currentExposureOffset.toStringAsFixed(1)}x',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RotatedBox(
                quarterTurns: 3,
                child: SizedBox(
                  height: 30,
                  child: Slider(
                    value: _currentExposureOffset,
                    min: _minAvailableExposureOffset,
                    max: _maxAvailableExposureOffset,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: (value) async {
                      setState(() {
                        _currentExposureOffset = value;
                      });
                      await _controller?.setExposureOffset(value);
                    },
                  ),
                ),
              ),
            )
          ]),
        ),
      );

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        _currentZoomLevel = value;
        _minAvailableZoom = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        _maxAvailableZoom = value;
      });
      _currentExposureOffset = 0.0;
      _controller?.getMinExposureOffset().then((value) {
        _minAvailableExposureOffset = value;
      });
      _controller?.getMaxExposureOffset().then((value) {
        _maxAvailableExposureOffset = value;
      });
      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    // get camera rotation
    final camera = _cameras[_cameraIndex];
    var rotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    // print(
    //     'lensDirection: ${camera.lensDirection}, rotation: ${camera.sensorOrientation} [$rotation], ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    if (Platform.isAndroid) {
      switch (camera.lensDirection) {
        case CameraLensDirection.front:
          switch (_controller!.value.deviceOrientation) {
            case DeviceOrientation.portraitUp:
              rotation = InputImageRotation.rotation270deg;
              break;
            case DeviceOrientation.landscapeLeft:
              rotation = InputImageRotation.rotation0deg;
              break;
            case DeviceOrientation.portraitDown:
              rotation = InputImageRotation.rotation90deg;
              break;
            case DeviceOrientation.landscapeRight:
              rotation = InputImageRotation.rotation180deg;
              break;
          }
          break;

        case CameraLensDirection.back:
          switch (_controller!.value.deviceOrientation) {
            case DeviceOrientation.portraitUp:
              rotation = InputImageRotation.rotation90deg;
              break;
            case DeviceOrientation.landscapeLeft:
              rotation = InputImageRotation.rotation0deg;
              break;
            case DeviceOrientation.portraitDown:
              rotation = InputImageRotation.rotation270deg;
              break;
            case DeviceOrientation.landscapeRight:
              rotation = InputImageRotation.rotation180deg;
              break;
          }
          break;

        case CameraLensDirection.external:
          break;
      }
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

Widget _startRecording() => Positioned(
        top: 100,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: () {
              startRecordingVideo();
              },
            backgroundColor: Colors.black54,
            child: const Icon(
              Icons.record_voice_over,
              size: 20,
            ),
          ),
        ),
      );

Widget _stopRecording() => Positioned(
        top: 180,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: () {
              stopRecordingVideo();
            },
            backgroundColor: Colors.black54,
            child: const Icon(
              Icons.stop,
              size: 20,
            ),
          ),
        ),
      );
}

/*
Future<void> startRecordingVideo() async {
    if (_controller.value.isInitialized) {
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
*/