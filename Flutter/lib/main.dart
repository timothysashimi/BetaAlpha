import 'package:orbital_app/pages/auth_page.dart';
import 'package:orbital_app/pages/create_account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:orbital_app/pages/login_page.dart';
import 'package:orbital_app/pages/forgot_password.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:orbital_app/pages/notif_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //final fcmToken = await FirebaseMessaging.instance.getToken();
  //print(fcmToken);

  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
            //container to include styling elements that will be applied to the log_in_screen widget
            decoration: const BoxDecoration(
                /*
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.red], //takes in a list of colours
            begin: Alignment.topLeft, //arguments that can format the gradient of background colour
            end: Alignment.bottomRight,
          ), */
                color: Colors.white),
            child: const AuthPage()),
      ),
      //Define app routes
      //initialRoute: '/',
      routes: {
        '/CreateAccountPage': (context) => const CreateAccountPage(),
        '/ForgotPasswordPage': (context) => const ForgotPasswordPage(),
      },
    ),
  );
}
