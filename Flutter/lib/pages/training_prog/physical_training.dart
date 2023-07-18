import 'package:flutter/material.dart';

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
                    
                  },
                ),
    );

}