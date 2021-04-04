// Packages:
import 'package:flutter/material.dart';

// Helpers:

// Utilities:

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Message...',
  fillColor: Colors.white,
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  // border: InputBorder.none,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
    borderRadius: const BorderRadius.all(
      const Radius.circular(22.0),
    ),
  ),

  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(22.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(22.0)),
  ),
);

const kMessageContainerDecoration = BoxDecoration(
  color: Colors.grey, // Color of the background of InputMessage
  border: Border(
    top: BorderSide(
      color: Colors.grey,
      width: 2.0,
    ),
  ),
);

// User Inputs

// Styling Functions:
InputDecoration getTextFieldDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.grey,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
  );
}
