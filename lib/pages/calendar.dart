import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
              _fetchEvents(_selectedDay);
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

    if (eventsForSelectedDay == null || eventsForSelectedDay.isEmpty) {
      return const Center(
        child: Text('No events for the selected day.'),
      );
    }

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

  void _fetchEvents(DateTime day) async {
    final eventsSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isEqualTo: day)
        .get();

    final events = eventsSnapshot.docs.map((doc) => doc['details'] as String).toList();

    setState(() {
      _events[day] = events;
    });
  }

  String _eventDetails = '';

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
                        onPressed: () => Navigator.of(context).pop(),
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
      final eventRef = FirebaseFirestore.instance.collection('events').doc();

      // Set the event details in the document
      await eventRef.set({
        'date': _selectedDay,
        'details': eventDetails,
      });

      // Update the events map to reflect the newly added event
      setState(() {
        _events.update(_selectedDay, (value) => [...value, eventDetails], ifAbsent: () => [eventDetails]);
      });
    }
  }

  void _deleteEvent(String event) async {
  // Find the reference to the event document in Firebase Firestore
  final eventSnapshot = await FirebaseFirestore.instance
      .collection('events')
      .where('date', isEqualTo: _selectedDay)
      .where('details', isEqualTo: event)
      .get();

  // Delete the event document
  await eventSnapshot.docs.first.reference.delete();

  // Update the events map to reflect the deleted event
  setState(() {
    _events[_selectedDay]!.remove(event);
  });
}
}