// Packages:
import 'package:flutter/material.dart';

// Screens:

// Components:

// Helpers:

// Utilities:
import 'package:flash_chat_latest/utilities/constants.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key key,
    @required this.hintText,
    this.onChanged,
  }) : super(key: key);

  final String hintText;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      obscuringCharacter: '*',
      textAlign: TextAlign.center,
      onChanged: (value) {
        //Do something with the user input.
        onChanged(value);
      },
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: getTextFieldDecoration(hintText),
    );
  }
}
