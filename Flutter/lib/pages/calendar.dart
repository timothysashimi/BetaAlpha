import 'package:flutter/material.dart';
import 'package:orbital_app/pages/notif_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;
import 'package:intl/intl.dart';

//import 'dart:developer' as devtools show log;
/*
firstDay: DateTime.utc(2010, 1, 1),
lastDay: DateTime.utc(2099, 12, 31),
*/
class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<dynamic>> _events = {};
  /*
  @override
  void initState() {
    
    for (var date = DateTime.now().subtract(const Duration(days: 15)); date.isBefore(DateTime.now().add(const Duration(days: 15))); date = date.add(const Duration(days: 1))) {
                _fetchEvents(date);
    }
    //_buildEventList();
    super.initState();
    
    //_fetchEventsRange(_selectedDay, _selectedDay.add(const Duration(days: 14)));
  }
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2099, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              //_fetchEventsRange(_selectedDay, _selectedDay.add(const Duration(days: 14)));
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
              //_fetchEventsRange(_selectedDay, _selectedDay.add(const Duration(days: 14)));
              for (var date = _selectedDay.subtract(const Duration(days: 30)); date.isBefore(_selectedDay.add(const Duration(days: 30))); 
                date = date.add(const Duration(days: 1))) {

                _fetchEvents(date);
              }
              //_fetchEventsRange(_focusedDay, _focusedDay.add(const Duration(days: 14)));
              devtools.log("fetch event called");
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
            eventLoader: (date) {
                  return _events[date] ?? [];
            },
          ),

          const SizedBox(height: 16),
          /*
          SizedBox(
            width: 130,
            child: TextButton(
              onPressed: () {
                _fetchAllEvents(DateTime.now());
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.grey[600], //just style the button
              ),
              child: const Text('Get all events'),
            ),
          ), */
          const SizedBox(
              child: Text('Click on a date to get all events!',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                )
              ),
            ),
          
          const SizedBox(height: 16),

          ElevatedButton(
              onPressed: _addEvent,
              child: const Text('Add Event'),
            ),
          

              
           
          const SizedBox(height: 16),
          Expanded(
           child: _buildEventList(),
          ),
        ],
      )
    

    );
  }
  
  Widget _buildEventList() {
    final eventsForSelectedDay = _events[_selectedDay];
    //devtools.log("build event list");
    if (eventsForSelectedDay == null || eventsForSelectedDay.isEmpty) {
      return const Center(
        child: Text('No events for the selected day.'),
      );
    }
    devtools.log("build event list");
    return ListView.builder(
      itemCount: eventsForSelectedDay.length,
      itemBuilder: (context, index) {
        final event = eventsForSelectedDay[index];

        return ListTile(
          title: Text(event),
          trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteEvent(event),
          )
        );
      },
    );
  } 

  void _fetchAllEvents(DateTime day) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;

    for (var date = day; date.isBefore(date.add(const Duration(days: 14))); date = date.add(const Duration(days: 1))) {
      final eventsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('events')
          .where('date', isEqualTo: date)
          //.where('date', isGreaterThanOrEqualTo: day)
          .get();

      devtools.log("fetch all events");
      final events = eventsSnapshot.docs.map((doc) => '${doc['details']}').toList();

      setState(() {
        _events[date] = events;
      });
    }
  }
  
  void _fetchEvents(DateTime day) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    final eventsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('events')
            .where('date', isEqualTo: day)
            //.where('date', isGreaterThanOrEqualTo: day)
            .get();

        devtools.log("fetch events");
        final events = eventsSnapshot.docs.map((doc) => '${doc['details']}').toList();

        setState(() {
          _events[day] = events;
        });
}

/*
void _fetchEventsRange(DateTime startDate, DateTime endDate) async {
  final user = FirebaseAuth.instance.currentUser;
  final userId = user!.uid;

  final eventsSnapshot = await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('events')
    .where('date', isGreaterThanOrEqualTo: DateTime.now())
    //.where('date', isLessThanOrEqualTo: endDate)
    .get();
   devtools.log("fetchEventsRange");
   Map<DateTime, List<dynamic>> eventsMap = Map<DateTime, List<dynamic>>();

  eventsSnapshot.docs.forEach((doc) {
    final eventDate = (doc['date'] as Timestamp).toDate();
    final eventDetails = doc['details'] as String;

    if (eventsMap.containsKey(eventDate)) {
      eventsMap[eventDate]!.add(eventDetails);
    } else {
      eventsMap[eventDate] = [eventDetails];
    }
  });

  setState(() {
    _events = eventsMap;
  });
}
*/


  String _eventDetails = '';
  int _eventID = 0;

  void _addEvent() async {
    // Show a dialog to get event details from the user
    final eventDetails = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Event Details'),
          onChanged: (value) {
            setState(() {
              _eventDetails = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Validate the event details before closing the dialog
              
              if (_eventDetails.isNotEmpty) {
                /*
                NotificationService.showNotification(id: )*/
                setState(() {
                  _eventID = UniqueKey().hashCode;
                });
                
                NotificationService().scheduleNotification(
                            id: _eventID,
                            title: "BetaAlpha",
                            body: _eventDetails,
                            scheduledNotificationDateTime: _selectedDay);
                Navigator.of(context).pop(_eventDetails);
              } else {
                // Show an error message if the event details are empty
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Please enter event details.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    // Check if the user entered event details
    if (eventDetails != null) {
      // Create a new document in the 'events' collection of Firestore
      //final eventRef = FirebaseFirestore.instance.collection('events').doc();
      final user = FirebaseAuth.instance.currentUser;
      final userId = user!.uid;

      // Create a new document in the 'events' collection of Firestore
      final eventRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc();

      // Set the event details in the document
      await eventRef.set({
        'date': _selectedDay,
        'details': eventDetails,
        'notification id': _eventID
      });

      // Update the events map to reflect the newly added event
      setState(() {
        _events.update(_selectedDay, (value) => [...value, eventDetails], ifAbsent: () => [eventDetails]);
      });
    }
  }

  void _deleteEvent(String event) async {
  //Find reference to the user in Firebase Firestore
  final user = FirebaseAuth.instance.currentUser;
  final userId = user!.uid;

  // Find the reference to the event document in Firebase Firestore
  final eventSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('events')
      .where('date', isEqualTo: _selectedDay)
      .where('details', isEqualTo: event)
      .get();

  // Delete the event document
  await eventSnapshot.docs.first.reference.delete();

  //Get event notif id to delete scheduled notification
  Map<String, dynamic> eventData = eventSnapshot.docs[0].data();
  int notifID = eventData['notification id'];

  NotificationService().cancelNotification(notifID);

  

  // Update the events map to reflect the deleted event
  setState(() {
    _events[_selectedDay]!.remove(event);
  });
}
}