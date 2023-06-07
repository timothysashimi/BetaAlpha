import 'package:flutter/material.dart';
import 'package:orbital_app/components/my_textfield.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  CreateAccountPageState createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //dispose TextEditingController to save memory

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  //using the data that the user entered after checking if the email, password, confirmed password entered by the user is correct
  void _signUp() {
    final enteredEmail = _emailController.text.trim();
    final enteredPassword = _passwordController.text.trim();
    final enteredConfirmedPassword = _confirmPasswordController.text.trim();

    if (enteredEmail == '' ||
        enteredPassword == '' ||
        enteredConfirmedPassword == '') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please ensure that all fields are not empty before submitting.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 120),
          Image.asset('assets/logo.jpeg',
              width: 300, alignment: const Alignment(10.0, 0.0)),
          const SizedBox(
              height:
                  20), //to indluce some space between image and text box(padding)
          const Align(
            alignment: Alignment(-0.65, 0),
            child: Text('Register',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),

          const Align(
            alignment: Alignment(-0.67, 0),
            child: Text('Your email:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 325,
            child: MyTextField(
              controller: _emailController,
              hintText: 'Email',
              obscureText: false,
            ),
          ),

          const SizedBox(height: 30),
          const Align(
            alignment: Alignment(-0.67, 0),
            child: Text('Password:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 325,
            child: MyTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: false,
            ),
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment(-0.67, 0),
            child: Text('Confirm Password:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          //Confirm password
          SizedBox(
            width: 325,
            child: MyTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm password',
              obscureText: false,
            ),
          ),
          const SizedBox(height: 30), //another padding between text and button
          //Sign up button
          SizedBox(
            width: 325,
            child: OutlinedButton(
              onPressed: () {
                _signUp();
              }, //annoymous function that does not have functionality yet
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white, //just style the button
                backgroundColor: Color(
                    int.parse("#389ce4".substring(1, 7), radix: 16) +
                        0xFF000000),
              ),
              child: const Text('Sign up',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
          // Already have an account? Sign up here!
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 300,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, //annoymous function that does not have functionality yet
                  style: TextButton.styleFrom(
                    foregroundColor: Color(
                        int.parse("#389ce4".substring(1, 7), radix: 16) +
                            0xFF000000), //just style the button
                  ),
                  child: const Text('Already have an account? Sign in here!'),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
