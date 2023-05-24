import 'package:orbital_app/log_in_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
     MaterialApp(
      home: Scaffold(
        body: Container( //container to include styling elements that will be applied to the log_in_screen widget
          decoration: const BoxDecoration(
            /*
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.red], //takes in a list of colours
              begin: Alignment.topLeft, //arguments that can format the gradient of background colour
              end: Alignment.bottomRight,
            ), */
            color: Colors.white
          ),
          child: const LogInScreen()
        ),
      ),
    ),
  );
}