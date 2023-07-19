import 'package:flutter/material.dart';

class ProgScreen extends StatefulWidget {
  const ProgScreen({
    required this.trainingProgram,
    super.key});

  final String trainingProgram;

  @override
  State<ProgScreen> createState() => _ProgScreen();
}

class _ProgScreen extends State<ProgScreen> {

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your training program!'),
        backgroundColor: const Color.fromARGB(185, 155, 39, 176)
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Image.asset('assets/logo.jpeg',
                  width: 300, alignment: const Alignment(10.0, 0.0)),
              _trainingProgram(),
              const SizedBox(height: 50),
              
            ]))));
  }

  Widget _trainingProgram() => SizedBox(
                height: 1000,
                width: 200,
                child: Text(widget.trainingProgram, style:(TextStyle(
                        color: Color.fromARGB(255, 81, 144, 196),
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      )))
                
  );
                
}