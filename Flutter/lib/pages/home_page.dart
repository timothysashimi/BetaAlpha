import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbital_app/pages/training_prog/training_screen.dart';
import 'package:orbital_app/pages/upload_video/gallery.dart';
import 'package:orbital_app/pages/upload_video/upload_video_page.dart';
import 'package:orbital_app/pages/profile/profile_page.dart';
import 'package:orbital_app/pages/calendar.dart';
import 'package:orbital_app/pages/home_page_widgets/line_chart_widget.dart';
import 'package:orbital_app/pages/training_prog/training_screen.dart';
import 'package:orbital_app/pages/google_mlkit/pose_dectector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path_provider/path_provider.dart';

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late Quote _quote;

  @override
  void initState() {
    super.initState();
    fetchQuoteIfNeeded(); // Fetch quote initially
    // Schedule daily updates
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      '1',
      'daily_quote_task',
      inputData: <String, dynamic>{}, // You can pass any data if needed
      frequency: const Duration(days: 1), // Repeat every 24 hours
    );
  }

  Future<void> fetchQuoteIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastQuoteDate = prefs.getString('lastQuoteDate');
    final currentDate = DateTime.now();

    // Check if a new quote should be fetched (e.g., if it has been more than 24 hours since the last fetch)
    if (lastQuoteDate == null ||
        currentDate.difference(DateTime.parse(lastQuoteDate)).inHours >= 24) {
      setState(() {
        fetchRandomQuote().then((fetchedQuote) {
          prefs.setString('lastQuoteDate', DateTime.now().toIso8601String());
          prefs.setString('quoteText', fetchedQuote.text);
          prefs.setString('quoteAuthor', fetchedQuote.author);
          _quote = fetchedQuote;
        }).catchError((error) {
          // Handle error if fetching quote fails
          print('Error fetching quote: $error');
        });
      });
    } else {
      // If a new quote is not needed, get the stored quote from SharedPreferences
      final storedQuoteText = prefs.getString('quoteText');
      final storedQuoteAuthor = prefs.getString('quoteAuthor');
      if (storedQuoteText != null && storedQuoteAuthor != null) {
        setState(() {
          _quote = Quote(text: storedQuoteText, author: storedQuoteAuthor);
        });
      }
    }
  }

  Future<void> fetchAndStoreQuote() async {
    try {
      final fetchedQuote = await fetchRandomQuote();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lastQuoteDate', DateTime.now().toIso8601String());
      prefs.setString('quoteText', fetchedQuote.text);
      prefs.setString('quoteAuthor', fetchedQuote.author);
      setState(() {
        _quote = fetchedQuote;
      });
    } catch (error) {
      // Handle error if fetching quote fails
      print('Error fetching quote: $error');
    }
  }

  Future<Quote> fetchRandomQuote() async {
    final category = 'fitness';
    final apiURL =
        Uri.parse('https://api.api-ninjas.com/v1/quotes?category=$category');
    final headers = {'X-Api-Key': 'ddVo/f1TaLq0sU3khWauMA==wkSTvHEgFDufZWl7'};

    final response = await http.get(apiURL, headers: headers);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final quoteData = jsonDecode(response.body);
      print(quoteData);
      if (quoteData is List && quoteData.isNotEmpty) {
        final quoteMap = quoteData[0] as Map<String, dynamic>;
        final quote = quoteMap['quote'] as String;
        final author = quoteMap['author'] as String;
        final fetchedQuote = Quote(text: quote, author: author);
        return fetchedQuote;
      } else {
        throw Exception('No quotes available for the given category');
      }
    } else {
      throw Exception(
          'Failed to fetch random quote. Error: ${response.statusCode}');
    }
  }

  void callbackDispatcher() {
    fetchAndStoreQuote();
    Workmanager().executeTask((task, inputData) {
      return Future.value(true);
    });
  }

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
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/mejdi.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text("BetaAlpha"),
              //flexibleSpace: FlexibleSpaceBar(background: Icon()),
              actions: [
                IconButton(
                    onPressed: signUserOut, icon: const Icon(Icons.logout))
              ])),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    child: Text(
                      "What's your goal for today?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 81, 144, 196),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 260,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        backgroundColor: Colors.deepOrangeAccent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Schedule your training!",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.calendar_month_outlined),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CalendarScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 260,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        backgroundColor: Colors.deepOrangeAccent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Need a training idea?",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.lightbulb),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TrainingScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 260,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        backgroundColor: Colors.deepOrangeAccent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Do a live recording!",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.camera),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PoseDetectorView()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  const Text(
                    "Quote of the day:",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 100, 98, 98),
                    ),
                  ),
                  FutureBuilder<Quote>(
                    future: Future.delayed(Duration(seconds: 3), () => _quote),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Display a loading indicator while fetching the quote.
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text(
                          'When the muscles fail, the mind takes over',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 100, 98, 98),
                          ),
                          textAlign: TextAlign.center,
                        ); // Display an error message if fetching the quote fails.
                      } else {
                        final quote = snapshot
                            .data; // The fetched quote will be available in snapshot.data.
                        return Container(
                          padding: EdgeInsets.all(
                              20.0), // Adjust the padding as needed
                          child: Text(
                            quote!.text,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 100, 98, 98),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
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
