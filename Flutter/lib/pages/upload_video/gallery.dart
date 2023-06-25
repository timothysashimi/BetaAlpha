import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orbital_app/components/video_data_server.dart';
import 'upload_video_page.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPage createState() => _GalleryPage();
}

class _GalleryPage extends State<GalleryPage> {
  late Future<List<VideoDataServer>> list;
  late List<VideoDataServer> _searchList;
  late List<VideoDataServer> aux_list;
  TextEditingController _searchController = new TextEditingController();
  bool _search = false;

  @override
  void initState() {
    // TODO: implement initState

    list = loadVideo();
    aux_list = [];

    _searchController.addListener(() {
      _searchList = aux_list
          .where((i) => i.title.startsWith(_searchController.text))
          .toList();
      _search = true;
      // onChip = getMemebrs(originaList);

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text("Gallery"), bottom: getSearchBar()),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.cloud),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UploadVideoPage()));
          },
        ),
        body: FutureBuilder(
            future: list,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new LinearProgressIndicator(
                    backgroundColor: Colors.deepPurpleAccent,
                  );
                default:
                  if (_search == true) {
                    return GridView.count(
                        crossAxisCount: 2,
                        children:
                            List<Widget>.generate(_searchList.length, (index) {
                          return GridVideo(
                            _searchList[index].title,
                            _searchList[index].description,
                            _searchList[index].userID,
                            _searchList[index].uri,
                          );
                        }));
                  } else {
                    return GridView.count(
                        crossAxisCount: 2,
                        children: List<Widget>.generate(snapshot.data.length,
                            (index) {
                          aux_list.add(VideoDataServer(
                            snapshot.data[index].title,
                            snapshot.data[index].description,
                            snapshot.data[index].userID,
                            snapshot.data[index].uri,
                          ));
                          return GridVideo(
                            snapshot.data[index].title,
                            snapshot.data[index].description,
                            snapshot.data[index].userID,
                            snapshot.data[index].uri,
                          );
                        }));
                  }
              }
            }));
  }

  getSearchBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              trailing: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              title: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: 'Search image  ', border: InputBorder.none),
              ),
            ),
          ),
        ));
  }
}

class GridVideo extends StatelessWidget {
  String title;
  String description;
  String userID;
  String uri;

  GridVideo(this.title, this.description, this.userID, this.uri);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          children: <Widget>[
            Image.network(
              uri,
              fit: BoxFit.cover,
            ),
            Text("Title: $title"),
            Text("Description: $description"),
          ],
        ),
      ),
    );
  }
}
