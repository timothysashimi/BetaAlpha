import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:orbital_app/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  //StatelessWidget is an abstract class
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // method to display error message
    void showErrorMessage(String message) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    }

    // creating the user
    try {
      // check if password is confirm correctly
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } else {
        showErrorMessage("Passwords don't match!");
      }
      //pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      //show error message
      showErrorMessage(e.code);
    }
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
                        50), //to induce some space between image and text box(padding)

                const Align(
                  alignment: Alignment(-0.1, 0),
                  child: Text('Let\'s create an account for you!',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 10),

                // Email Field
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Password Field
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // Confirm Password Field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(
                    height: 30), //another padding between text and button
                SizedBox(
                  width: 325,
                  child: OutlinedButton(
                    onPressed:
                        signUserUp, //annoymous function that does not have functionality yet
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white, //just style the button
                      backgroundColor: Color(
                          int.parse("#389ce4".substring(1, 7), radix: 16) +
                              0xFF000000),
                    ),
                    child: const Text('Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                // Forget password and sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
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
