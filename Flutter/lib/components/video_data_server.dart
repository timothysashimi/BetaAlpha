import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class VideoDataServer {
  String title;
  String description;
  String userID;
  String uri;

  VideoDataServer(this.title, this.description, this.userID, this.uri);
}

Future<List<VideoDataServer>> loadVideo() async {
  //complete fetch ....
  var url = Uri.parse('http://0.0.0.0:5000/api/');
  var data = await http.get(url);
  var jsondata = json.decode(data.body);
  List<VideoDataServer> newslist = [];
  for (var data in jsondata) {
    VideoDataServer n = VideoDataServer(
        data['title'], data['description'], data['userID'], data['url']);
    newslist.add(n);
  }

  return newslist;
}
