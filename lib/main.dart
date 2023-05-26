import 'package:orbital_app/pages/auth_page.dart';
import 'package:orbital_app/pages/create_account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:orbital_app/pages/log_in_screen.dart';
import 'package:orbital_app/pages/forgot_password.dart';



import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
