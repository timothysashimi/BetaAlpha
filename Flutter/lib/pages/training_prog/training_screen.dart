import 'package:flutter/material.dart';

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
              _climbingSpecificWorkout(),
              const SizedBox(height: 50),
              _PhysicalTrainingWorkout()
            ]))));
  }

  Widget _climbingSpecificWorkout() => SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    backgroundColor: Colors.deepOrangeAccent
                  ),
                  child: Row(
                    children: [
                      const Text("Climbing specific workout"),
                      SizedBox(width:10),
                      Icon(Icons.sports_gymnastics_outlined)
                    ],
                  ),
                  onPressed: () {
        
                  },
                ),
    );
  
   Widget _PhysicalTrainingWorkout() => SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    backgroundColor: Colors.deepOrangeAccent
                  ),
                  child: Row(
                    children: [
                      const Text("Physical Training workout"),
                      const SizedBox(width:10),
                      const Icon(Icons.run_circle_outlined)
                    ],
                  ),
                  onPressed: () {
        
                  },
                ),
              );

}