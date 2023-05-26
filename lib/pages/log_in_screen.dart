import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:orbital_app/components/my_textfield.dart';

class LogInScreen extends StatefulWidget {
  //StatelessWidget is an abstract class

  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //attempt to sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      //pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      //wrong email
      if (e.code == 'user-not-found') {
        //show error
        wrongEmailMessage();
      }
      //wrong password
      else if (e.code == 'wrong-password') {
        //show error to user
        wrongPasswordMessage();
      }
    }
  }

  // method to display wrong email
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Email'),
        );
      },
    );
  }

  // method to display wrong password
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Password'),
        );
      },
    );
  }

  @override
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Image.asset('assets/logo.jpeg',
                    width: 300, alignment: const Alignment(10.0, 0.0)),
                const SizedBox(
                    height:
                        50), //to indluce some space between image and text box(padding)
                const Align(
                  alignment: Alignment(-0.65, 0),
                  child: Text('Sign In',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),

                /*const Align(
                alignment: Alignment(-0.67, 0),
                child: Text('Email:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),*/
                const SizedBox(height: 10),

                // Email Field
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 20),
                /*const Align(
                alignment: Alignment(-0.67, 0),
                child: Text('Password:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ), */
                const SizedBox(height: 10),

                // Password Field
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(
                    height: 30), //another padding between text and button
                SizedBox(
                  width: 325,
                  child: OutlinedButton(
                    onPressed:
                        signUserIn, //annoymous function that does not have functionality yet
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white, //just style the button
                      backgroundColor: Color(
                          int.parse("#389ce4".substring(1, 7), radix: 16) +
                              0xFF000000),
                    ),
                    child: const Text('Sign in',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                // Forget password and sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 130,
                      child: TextButton(
                        onPressed:
                            () {
                              Navigator.pushNamed(context, '/ForgotPasswordPage');
                            }, 
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Colors.grey[600], //just style the button
                        ),
                        child: const Text('Forgot password'),
                      ),
                    ),
                    const SizedBox(width: 30),
                    SizedBox(
                      width: 100,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/CreateAccountPage');
                        }, //annoymous function that does not have functionality yet
                        style: TextButton.styleFrom(
                          foregroundColor: Color(
                              int.parse("#389ce4".substring(1, 7), radix: 16) +
                                  0xFF000000), //just style the button
                        ),
                        child: const Text('Sign up'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
