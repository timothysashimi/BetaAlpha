import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orbital_app/components/my_textfield.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  
  //dispose TextEditingController to save memory

  @override
  void dispose() {
    _emailController.dispose();
    
    super.dispose();

  }
  
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text.trim());
      
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('Password reset link sent! Check your email'),
          );
        },
      ); 
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        }
      );

    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
        
          mainAxisSize: MainAxisSize.min, 
          children: [
            const SizedBox(height: 60),
            Row(
              children: [
                const SizedBox(width: 20),
                //Back button to go back to sign in page
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, //annoymous function that does not have functionality yet
                  style: TextButton.styleFrom(
                    foregroundColor: Color(int.parse("#389ce4".substring(1, 7), radix: 16) + 0xFF000000), //just style the button
                    
                    ),
                  child: const Text('Back'),
                
                  ),
              ]
            ),
            const SizedBox(height: 120),
            Image.asset('assets/logo.jpeg',  width: 300, alignment: const Alignment(10.0, 0.0) ),
            const SizedBox(height: 20), //to indluce some space between image and text box(padding)
            /*
            const Align(alignment: Alignment(-0.65, 0), child: Text('Register', 
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold)        
              ),
            ), */
            const SizedBox(height: 20),
            //Enter email to reset password
            const Align(alignment: Alignment(-0.67, 0), 
              child: Text('Enter your email and we will send you a password reset link.', 
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
            width: 325, 
            child: MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                

              ),
            
            const SizedBox(height: 30),
            
            // Reset password button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                SizedBox(width: 300, 
                
                  child:  OutlinedButton(
                    onPressed: () {
                      passwordReset();
                    }, //annoymous function that does not have functionality yet
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white, //just style the button
                      backgroundColor: Color(int.parse("#389ce4".substring(1, 7), radix: 16) + 0xFF000000), 
                      
                    ),
                    child: const Text('Reset password', style: TextStyle(
                      color: Colors.white,
                    fontSize: 20,
                      fontWeight: FontWeight.bold)
                    ),
                  
                  ),
                ),
              ],
            )
          ],
        ),
      
      )
    
    );
    
  }
}