import 'package:flutter/material.dart';
import 'package:orbital_app/pages/training_prog/climbing_training.dart';
import 'package:orbital_app/pages/training_prog/physical_training.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreen();
}

class _TrainingScreen extends State<TrainingScreen> {
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Training Program'),
            backgroundColor: const Color.fromARGB(185, 155, 39, 176)),
        body: SingleChildScrollView(
            child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 10),
          Image.asset('assets/logo.jpeg',
              width: 300, alignment: const Alignment(10.0, 0.0)),
          const SizedBox(height: 20),
          _buildClimbingSpecificWorkoutSection(),
          const SizedBox(height: 50),
          _buildPhysicalTrainingWorkoutSection(),
          const SizedBox(height: 50),
        ]))));
  }

  Widget _buildClimbingSpecificWorkoutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Image.asset('assets/magnus.jpeg'),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 50,
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.deepOrangeAccent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Climbing specific workout"),
                    SizedBox(width: 10),
                    Icon(Icons.sports_gymnastics_outlined),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClimbingTrainingScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalTrainingWorkoutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Image.asset('assets/training.jpeg'),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            width: 400,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.deepOrangeAccent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Physical Training workout"),
                  SizedBox(width: 10),
                  Icon(Icons.run_circle_outlined),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PhysicalTrainingScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
