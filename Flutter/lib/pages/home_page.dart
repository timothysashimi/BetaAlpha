import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbital_app/pages/training_prog/training_screen.dart';
import 'package:orbital_app/pages/upload_video/gallery.dart';
import 'package:orbital_app/pages/upload_video/upload_video_page.dart';
import 'package:orbital_app/pages/profile/profile_page.dart';
import 'package:orbital_app/pages/calendar.dart';
import 'package:orbital_app/pages/home_page_widgets/line_chart_widget.dart';
import 'package:orbital_app/pages/training_prog/training_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  
  @override //Abstract Method
  Widget build(context) {
    return Scaffold(
      
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(300.0),
        child: AppBar(
        backgroundColor: const Color.fromARGB(185, 155, 39, 176),
        
        title: const Text("BetaAlpha"),
        //flexibleSpace: FlexibleSpaceBar(background: Icon()),
        actions: [
        IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
      ])),
      

      body: SingleChildScrollView(
        
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          //LineChartWidget(),
          const SizedBox(height: 10),
          
            
            Row(
              children: [
                SizedBox(width: 70),
                SizedBox( 
                  height: 30,
                  child: Text("What's your goal today?",
                      style:(TextStyle(
                        color: Color.fromARGB(255, 81, 144, 196),
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ))),
                ),
              ],
            )
          ,
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 20),
              SizedBox(
                height: 50,
                width: 210,
                child: ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    backgroundColor: Colors.deepOrangeAccent
                  ),
                  child: Row(
                    children: [
                      const Text("Schedule your training!"),
                      SizedBox(width:10),
                      Icon(Icons.calendar_month_outlined)
                    ],
                  ),
                  onPressed: () {
                    // Navigate to home page
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => CalendarScreen()));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const SizedBox(width: 20),
              SizedBox(
                height: 50,
                width: 210,
                child: ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    backgroundColor: Colors.deepOrangeAccent
                  ),
                  child: Row(
                    children: [
                      const Text("Need a training idea?"),
                      SizedBox(width:10),
                      Icon(Icons.lightbulb)
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => TrainingScreen()));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
          
            "Quote of the day: Winners train, losers complain", 
          )
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 56.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // Navigate to home page
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.cloud_upload),
                onPressed: () {
                  // Navigate to upload video page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => GalleryPage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  // Navigate to profile page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ProfilePage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
