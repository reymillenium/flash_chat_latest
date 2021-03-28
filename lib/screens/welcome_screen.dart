// Packages:
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// Screens:
import 'package:flash_chat_latest/screens/login_screen.dart';
import 'package:flash_chat_latest/screens/registration_screen.dart';

// Components:
import 'package:flash_chat_latest/components/auth_button.dart';

// Helpers:

// Utilities:
import 'package:flash_chat_latest/utilities/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation curvedAnimation;
  Animation colorTweenAnimationBackground;
  Animation colorTweenAnimationLogin;
  Animation colorTweenAnimationRegister;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this, // The Ticker (this current _WelcomeScreenState object)
      upperBound: 1, // It can't be greater than 1 with curved animations
    );

    // Curved Animation:
    curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceOut,
    );

    // Color Tween Animations:
    colorTweenAnimationBackground = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(animationController);

    colorTweenAnimationLogin = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.lightBlueAccent,
    ).animate(animationController);

    colorTweenAnimationRegister = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.blueAccent,
    ).animate(animationController);

    // Animates from 0 to 1 in 60 steps:
    animationController.forward();

    // Animates in reverse:
    // animationController.reverse(from: 1.0);

    // animationController.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animationController.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     animationController.forward();
    //   }
    // });

    // The listener takes a callback. Gets executed in every tick of the ticker?
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorTweenAnimationBackground.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                // App Logo:
                Hero(
                  tag: 'flash_logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: curvedAnimation.value * 100,
                  ),
                ),

                // App Title:
                TextLiquidFill(
                  waveDuration: Duration(seconds: 1),
                  loadDuration: Duration(seconds: 2),
                  text: 'Flash Chat',
                  waveColor: Colors.black,
                  boxBackgroundColor: colorTweenAnimationBackground.value,
                  textStyle: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                  boxHeight: 100.0,
                  boxWidth: 230.0,
                ),
              ],
            ),

            // Separation:
            SizedBox(
              height: 48.0,
            ),

            // Login Screen button
            Hero(
              tag: 'login_button',
              child: AuthButton(
                color: colorTweenAnimationLogin.value,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                label: 'Log In',
              ),
            ),

            // Registration Screen button
            Hero(
              tag: 'register_button',
              child: AuthButton(
                color: colorTweenAnimationRegister.value,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
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
