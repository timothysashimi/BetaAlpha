import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // method to display error message
  void showErrorMessage(String message) {
    String errorMessage;
    switch (message) {
      case 'invalid-email':
        errorMessage = 'Invalid email address';
        break;
      case 'user-disabled':
        errorMessage = 'The user corresponding to this email has been disabled';
        break;
      case 'user-not-found':
        errorMessage = 'User not found';
        break;
      case 'wrong-password':
        errorMessage = 'Invalid password';
        break;
      case 'weak-password':
        errorMessage = 'Password requires at least 6 characters';
        break;
      case 'email-already-in-use':
        errorMessage = 'Email is already in use';
        break;
      default:
        errorMessage = message;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  //yet to use
  //password validator
  bool passwordMeetsCriteria(String password) {
    // Check if password contains at least one letter and one number
    bool hasLetter = false;
    bool hasNumber = false;

    for (var char in password.split('')) {
      if (char.contains(RegExp(r'[a-zA-Z]'))) {
        hasLetter = true;
      } else if (char.contains(RegExp(r'[0-9]'))) {
        hasNumber = true;
      }
    }

    return hasLetter && hasNumber;
  }

  // sign user up method
  Future<void> signUserUp() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // creating the user
    try {
      // check if password is confirmed correctly
      if (!passwordMeetsCriteria(passwordController.text) ||
          !passwordMeetsCriteria(confirmPasswordController.text)) {
        throw FirebaseAuthException(
            code: 'Password should contain at least one letter and one number');
      }
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        FirebaseFirestore.instance
            .collection('userProfile')
            .doc(userCredential.user!.email)
            .set({
          'username': emailController.text.split('@')[0],
          'bio': 'Empty bio...',
          'goal': 'Please set your goal for the month',
        });
      } else {
        // Passwords don't match
        throw FirebaseAuthException(code: 'password-mismatch');
      }
      //pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      //show error message
      if (e.code == 'password-mismatch') {
        showErrorMessage("Passwords don't match!");
      } else {
        showErrorMessage(e.code);
      }
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
