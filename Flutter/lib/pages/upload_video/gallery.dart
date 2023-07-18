import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orbital_app/components/video_object.dart';
import 'package:orbital_app/components/gallery_video_player.dart';
import 'upload_video_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("userProfile");
  List<VideoObject> videos = [];

  String filter = '';

  Future<void> _refreshVideos() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      videos = []; // Clear the existing video list
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(currentUser.email)
          .collection('videos')
          .get();

      List<VideoObject> updatedVideos = snapshot.docs
          .map<VideoObject>((doc) => VideoObject.fromSnapshot(doc))
          .where((video) =>
              video.title.toLowerCase().contains(filter.toLowerCase()))
          .toList();

      setState(() {
        videos = updatedVideos; // Update the video list with new data
      });
    } catch (e) {
      print('Error refreshing videos: $e');
      // Handle any error that occurred while refreshing videos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Gallery'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshVideos,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    filter = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('userProfile')
                    .doc(currentUser.email)
                    .collection('videos')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  // Filter videos based on search query
                  videos = snapshot.data!.docs
                      .map<VideoObject>((doc) => VideoObject.fromSnapshot(doc))
                      .where((video) => video.title
                          .toLowerCase()
                          .contains(filter.toLowerCase()))
                      .toList();

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      VideoObject video = videos[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: GridTile(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GalleryVideoPlayerPage(video: video),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          video.url.replaceAll('.mp4', '.jpg')),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    color: Colors.black54,
                                    child: Text(
                                      video.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        letterSpacing: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadVideoPage()),
          );
        },
      ),
    );
  }
}
