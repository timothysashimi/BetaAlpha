import 'dart:io';
import 'package:flutter/material.dart';

class VideoData {
  String title;
  String description;
  File videoFile;

  VideoData({
    required this.title,
    required this.description,
    required this.videoFile,
  });
}
