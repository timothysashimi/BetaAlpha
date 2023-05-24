import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  CreateAccountPageState createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        
        mainAxisSize: MainAxisSize.min, 
        children: [
          const SizedBox(height: 120),
          Image.asset('assets/logo.jpeg',  width: 300, alignment: const Alignment(10.0, 0.0) ),
          const SizedBox(height: 20), //to indluce some space between image and text box(padding)
          const Align(alignment: Alignment(-0.65, 0), child: Text('Register', 
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold)        
            ),
          ),
          const SizedBox(height: 20),

          const Align(alignment: Alignment(-0.67, 0), child: Text('Your email:', 
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
          width: 325, 
          child: TextField(decoration: InputDecoration(
              filled: true,
              
              fillColor: Color(int.parse("#e8ccfc".substring(1, 7), radix: 16) + 0xFF000000),

              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3.0),
                borderRadius: BorderRadius.circular(10.0),
              ),

              hintText: 'Email',
              contentPadding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
              

            ),
          ),
          ),
          const SizedBox(height: 30),
          const Align(alignment: Alignment(-0.67, 0), child: Text('Password:', 
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
          width: 325, 
          child: TextField(decoration: InputDecoration(
              filled: true,
              fillColor: Color(int.parse("#e8ccfc".substring(1, 7), radix: 16) + 0xFF000000),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3.0),
                borderRadius: BorderRadius.circular(10.0),
              ),

              hintText: 'Password',
              contentPadding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
              

            ),
          ),
          ),
          const SizedBox(height: 30),
          const Align(alignment: Alignment(-0.67, 0), child: Text('Confirm Password:', 
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
          width: 325, 
          child: TextField(decoration: InputDecoration(
              filled: true,
              fillColor: Color(int.parse("#e8ccfc".substring(1, 7), radix: 16) + 0xFF000000),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3.0),
                borderRadius: BorderRadius.circular(10.0),
              ),

              hintText: 'Password',
              contentPadding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
              

            ),
          ),
          ),
          const SizedBox(height: 30), //another padding between text and button
          SizedBox(width: 325, 
            
            child: OutlinedButton(
              onPressed: () {}, //annoymous function that does not have functionality yet
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white, //just style the button
                backgroundColor: Color(int.parse("#389ce4".substring(1, 7), radix: 16) + 0xFF000000), 
                
              ),
              child: const Text('Sign up', style: TextStyle(
                color: Colors.white,
               fontSize: 20,
                fontWeight: FontWeight.bold)
              ),
            
            ),
          ),
          const SizedBox(height:20),
          // Forget password and sign up
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              
              SizedBox(width: 300, 
              
              child: TextButton(
               onPressed: () {
                Navigator.pop(context);
               }, //annoymous function that does not have functionality yet
               style: TextButton.styleFrom(
                 foregroundColor: Color(int.parse("#389ce4".substring(1, 7), radix: 16) + 0xFF000000), //just style the button
                
                ),
               child: const Text('Already have an account? Sign in here!'),
            
               ),
              ),
            ],
          )
        ],
      ),
      
    
    
    );
    
  }
}