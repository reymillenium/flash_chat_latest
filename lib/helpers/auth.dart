// Packages:
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// Screens:
import 'package:flash_chat_latest/screens/welcome_screen.dart';
import 'package:flash_chat_latest/screens/login_screen.dart';
import 'package:flash_chat_latest/screens/registration_screen.dart';
import 'package:flash_chat_latest/screens/chat_screen.dart';

// Components:

// Helpers:

// Utilities:
import 'package:flash_chat_latest/utilities/constants.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User loggedInUser;

  Future<User> handleSignInEmail(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    final User currentUser = await _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInEmail succeeded: $user');

    return user;
  }

  Future<User> handleSignUp(email, password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final User user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    return user;
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      // print('user = $user');
      if (user != null) {
        loggedInUser = user;
        print('loggedInUser.email = ${loggedInUser.email}');
      }
    } catch (e) {
      print(e);
    }
  }

  void handleSignOut() {
    _auth.signOut();
  }

  void showToastError(String errorMessage, BuildContext context) {
    showToast(
      errorMessage,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.center,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}
