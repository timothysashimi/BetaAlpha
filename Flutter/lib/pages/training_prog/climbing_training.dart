import 'package:flutter/material.dart';

class ClimbingTrainingScreen extends StatefulWidget {
  const ClimbingTrainingScreen({super.key});

  @override
  State<ClimbingTrainingScreen> createState() => _ClimbingTrainingScreen();
}

class _ClimbingTrainingScreen extends State<ClimbingTrainingScreen> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Climbing Training Workouts'),
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
              _enduranceTraining(),
              const SizedBox(height: 50),
              _powerEnduranceTraining(),
              const SizedBox(height: 50),
              _hangboardingTraining(),
              const SizedBox(height: 50),
              _campusTraining()
            ]))));
  }

  Widget _enduranceTraining() => SizedBox(
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
                      const Text("Endurance Training"),
                      SizedBox(width:10),
                      Icon(Icons.run_circle_outlined)
                    ],
                  ),
                  onPressed: () {
                    
                  },
                ),
    );

    Widget _powerEnduranceTraining() => SizedBox(
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
                      const Text("Power Endurance Training"),
                      SizedBox(width:10),
                      Icon(Icons.sports_martial_arts_rounded)
                    ],
                  ),
                  onPressed: () {
                    
                  },
                ),
    );

    Widget _hangboardingTraining() => SizedBox(
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
                      const Text("Hangboarding Training"),
                      SizedBox(width:10),
                      Icon(Icons.bolt_sharp)
                    ],
                  ),
                  onPressed: () {
                    
                  },
                ),
    );

    Widget _campusTraining() => SizedBox(
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
                      const Text("Campus Training"),
                      SizedBox(width:10),
                      Icon(Icons.sports_gymnastics_outlined)
                    ],
                  ),
                  onPressed: () {
                    
                  },
                ),
    );
}