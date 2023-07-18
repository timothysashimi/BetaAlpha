import 'package:flutter/material.dart';
import 'package:orbital_app/pages/training_prog/prog_screen.dart';


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
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ProgScreen(trainingProgram: 
                            '''
                            Warm up: Dynamic stretching, light jogging, and mobility exercises.

                            Pyramid training: Select 5-6 boulder problems of increasing difficulty. 
                            Start by completing one repetition of the easiest problem, then move on to one repetition of the second easiest, and continue until you reach the hardest problem.
                            Rest for 3-5 minutes, then reverse the pyramid by completing one repetition of each problem in reverse order. 
                            Focus on maintaining good form and a steady pace throughout the pyramid.

                            Traverse training: Find a section of the climbing wall or bouldering area with a continuous traverse. 
                            Perform multiple laps of traversing, aiming for a sustained effort. 
                            Focus on fluid movement and breathing control. Complete 3-4 sets, resting 2-3 minutes between sets.

                            Cool down: Static stretching and light cardio.

                            '''
                        ))
                    );
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
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ProgScreen(trainingProgram: 
                            '''
                            Warm up: Dynamic stretching, light jogging, and mobility exercises.
                                                  
                            Circuit: Select 5-6 boulder problems that challenge your power endurance. 
                            Perform each problem one after the other without rest, aiming for 3-4 sets with a 2-minute rest between sets.

                            Campus board exercises: Perform 4-5 sets of 5-8 campus board repetitions with 2-3 minutes of rest between sets.
                            Cool down: Static stretching and light cardio.'''
                        ))
                    );
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
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ProgScreen(trainingProgram: 
                            '''
                            Warm-up set: Do 2 sets of 10-second hangs on the largest, most positive holds on the hangboard with an open-hand grip. Rest for 2 minutes between sets.

                            Working sets: Perform 3-4 sets of the following hangs, focusing on different grip positions:

                            a. Half-crimp: Hang for 10 seconds, rest for 2-3 minutes.
                            b. Three-finger drag: Hang for 10 seconds, rest for 2-3 minutes.
                            c. Open-hand pockets: Hang for 10 seconds, rest for 2-3 minutes.
                            d. Pinches: Hang for 10 seconds, rest for 2-3 minutes.
                            e. Slopers: Hang for 10 seconds, rest for 2-3 minutes.

                            Progression set: Finish the workout with one challenging set of max hangs on your strongest grip position. Hang for as long as you can maintain proper form, aiming for a duration of 10-15 seconds. Rest for 3-4 minutes between attempts.

                            Cool-down: After completing the hangboarding workout, perform gentle stretching exercises for your fingers, wrists, forearms, and shoulders. This will help promote flexibility and reduce the risk of injury.

                            Important Considerations:

                            Be mindful of your limits and avoid overtraining. Start with shorter hang durations and gradually increase the intensity and duration as your strength improves.
                            Always prioritize proper form and technique over intensity. Quality hangs with good form are more effective than longer hangs with poor form.
                            Allow for sufficient rest and recovery between hangboarding sessions. Aim to have at least 48 hours of rest between workouts to allow your muscles and tendons to recover and adapt.
                            If you're new to hangboarding or have any concerns, consider consulting with a qualified climbing coach to ensure proper technique and to tailor the workout to your specific needs and goals.
                            '''
                        ))
                    );
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
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ProgScreen(trainingProgram: 
                            '''
                            Warm up: Dynamic stretching, light jogging, and mobility exercises.

                            Basic laddering: Start by placing both hands on the bottom rung of the campus board. 
                            Perform 5-7 repetitions of alternating hand movements, moving up one rung at a time. 
                            Rest for 2-3 minutes between sets. Complete 3-4 sets.

                            Lock-off training: Hang on the lowest rung of the campus board with both hands. 
                            Pull up and hold the position for 3-5 seconds, then slowly lower down. 
                            Perform 4-6 repetitions with 2-3 minutes of rest between sets. Complete 3-4 sets.

                            Cool down: Static stretching and light cardio.
                            '''
                        ))
                    );
                  },
                ),
    );
}