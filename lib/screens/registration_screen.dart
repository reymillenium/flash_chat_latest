// Packages:
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screens:
import 'package:flash_chat_latest/screens/chat_screen.dart';

// Components:
import 'package:flash_chat_latest/components/auth_button.dart';
import 'package:flash_chat_latest/components/text_input.dart';
import 'package:flash_chat_latest/components/email_input.dart';
import 'package:flash_chat_latest/components/password_input.dart';

// Helpers:

// Utilities:
import 'package:flash_chat_latest/utilities/constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'flash_logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),

            // Email Input:
            EmailInput(
              hintText: 'Enter your email',
              onChanged: (value) {
                email = value;
              },
            ),

            SizedBox(
              height: 8.0,
            ),

            // Password Input:
            PasswordInput(
              hintText: 'Enter your password',
              onChanged: (value) {
                password = value;
              },
            ),

            SizedBox(
              height: 24.0,
            ),

            // Registration Screen button
            Hero(
              tag: 'register_button',
              child: AuthButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  // print(email);
                  // print(password);
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                label: 'Register',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
