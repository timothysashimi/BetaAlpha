import 'package:flutter/material.dart';
import 'package:orbital_app/pages/training_prog/prog_screen.dart';


class PhysicalTrainingScreen extends StatefulWidget {
  const PhysicalTrainingScreen({super.key});

  @override
  State<PhysicalTrainingScreen> createState() => _PhysicalTrainingScreen();
}

class _PhysicalTrainingScreen extends State<PhysicalTrainingScreen> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical Training Workouts'),
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
              _coreTraining(),
              const SizedBox(height: 50),
              _pullCalisthenicsTraining(),
              const SizedBox(height: 50),
              _pushCalisthenicsTraining(),
              const SizedBox(height: 50),
              _pullWeightsTraining(),
              const SizedBox(height: 50),
              _pushWeightsTraining()
            ]))));
  }

  Widget _coreTraining() => SizedBox(
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
                      const Text("Core Training"),
                      SizedBox(width:10),
                      Icon(Icons.run_circle_outlined)
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ProgScreen(trainingProgram: 
                            '''
                            Plank:
                            Rest for 30 seconds and repeat for a total of 3 sets.

                            Russian Twists:
                            Perform 12-15 reps on each side, rest for 30 seconds, and repeat for a total of 3 sets.
                            
                            Bicycle Crunches:
                            Perform 12-15 reps on each side, rest for 30 seconds, and repeat for a total of 3 sets.
                            
                            Mountain Climbers:
                            Rest for 30 seconds and repeat for a total of 3 sets.
                            
                            Leg Raises:
                            Perform 10-12 reps, rest for 30 seconds, and repeat for a total of 3 sets.
                            
                            Side Planks:
                            Hold this position for 30 seconds to 1 minute on each side, focusing on engaging your obliques and maintaining proper alignment.
                            Rest for 30 seconds and repeat for a total of 3 sets.
                            '''
                        ))
                    );
                  },
                ),
    );

    Widget _pullCalisthenicsTraining() => SizedBox(
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
                      const Text("Pull Calisthenics Training"),
                      SizedBox(width:10),
                      Icon(Icons.sports_martial_arts_rounded)
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ProgScreen(trainingProgram: 
                            '''
                            Pull-Ups:
                            Perform 8-12 reps, rest for 30-60 seconds, and repeat for a total of 3-4 sets.
                            
                            Archer pull ups:
                            Perform 10-15 reps, rest for 30-60 seconds, and repeat for a total of 3-4 sets.
                            
                            Australian Pull-Ups:
                            Perform 10-15 reps, rest for 30-60 seconds, and repeat for a total of 3-4 sets.
                            
                            Close grip pull ups:
                            Perform 10-15 reps, rest for 30-60 seconds, and repeat for a total of 3-4 sets.
                            
                            Wide grip pull ups:
                            Perform 8-12 reps, rest for 30-60 seconds, and repeat for a total of 3-4 sets.
                            '''
                        ))
                    );
                  },
                ),
    );

    Widget _pushCalisthenicsTraining() => SizedBox(
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
                      const Text("Push Calisthenics Training"),
                      SizedBox(width:10),
                      Icon(Icons.bolt_sharp)
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ProgScreen(trainingProgram: 
                            '''
                            Standard Push-Ups:
                            Perform 10-20 reps, rest for 30-60 seconds, and repeat for a total of 3-4 sets.

                            Diamond Push-Ups:
                            Perform 10-20 reps, rest for 30-60 seconds, and repeat for a total of 3-4 sets.

                            Narrow Push-Ups:
                            Perform 10-20 reps, rest for 30-60 seconds, and repeat for a total of 3-4 sets.

                            Wide Push-Ups:
                            Perform 10-20 reps, rest for 30-60 seconds, and repeat for a total of 3-4 sets.

                            Decline Push-Ups:
                            Perform 10-20 reps, rest for 30-60 seconds, and repeat for a total of 3-4 sets.
                            '''
                        ))
                    );
                  },
                ),
    );

    Widget _pullWeightsTraining() => SizedBox(
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
                      const Text("Pull Weights Training"),
                      SizedBox(width:10),
                      Icon(Icons.sports_martial_arts_rounded)
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ProgScreen(trainingProgram: 
                            '''
                            Deadlifts:
                            Perform 4-5 sets of 6-8 reps, resting for 2-3 minutes between sets.
                            
                            Bent-Over Rows:
                            Perform 3-4 sets of 8-12 reps, resting for 1-2 minutes between sets.
                            
                            Pull-Ups:
                            Perform 3-4 sets of as many reps as you can, resting for 1-2 minutes between sets.
                            
                            Single-Arm Dumbbell Rows:
                            Perform 3-4 sets of 8-12 reps on each side, resting for 1-2 minutes between sets.
                            
                            Lat Pulldowns:
                            Perform 3-4 sets of 8-12 reps, resting for 1-2 minutes between sets.
                            
                            Bicep Curls:
                            Perform 3-4 sets of 8-12 reps, resting for 1-2 minutes between sets.
                            '''
                        ))
                    );
                  },
                ),
    );

    Widget _pushWeightsTraining() => SizedBox(
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
                      const Text("Push Weights Training"),
                      SizedBox(width:10),
                      Icon(Icons.bolt_sharp)
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ProgScreen(trainingProgram: 
                            '''
                            Barbell Bench Press:
                            Perform 4-5 sets of 6-8 reps, resting for 2-3 minutes between sets.

                            Dumbbell Shoulder Press:
                            Perform 3-4 sets of 8-12 reps, resting for 1-2 minutes between sets.

                            Incline Dumbbell Bench Press:
                            Perform 3-4 sets of 8-12 reps, resting for 1-2 minutes between sets.

                            Tricep Dips:
                            Perform 3-4 sets of 8-12 reps, resting for 1-2 minutes between sets.

                            Push-Ups:
                            Perform 3-4 sets of as many reps as you can, resting for 1-2 minutes between sets.
                            
                            Cable Flyes:
                            Perform 3-4 sets of 8-12 reps, resting for 1-2 minutes between sets.
                            '''
                        ))
                    );
                  },
                ),
    );

}