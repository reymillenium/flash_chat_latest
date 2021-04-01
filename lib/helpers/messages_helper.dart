// Packages:
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Allows to use FieldValue, etc
import 'package:bubble/bubble.dart';

// Screens:
import 'package:flash_chat_latest/screens/welcome_screen.dart';
import 'package:flash_chat_latest/screens/login_screen.dart';
import 'package:flash_chat_latest/screens/registration_screen.dart';
import 'package:flash_chat_latest/screens/chat_screen.dart';

// Components:

// Helpers:
import 'package:flash_chat_latest/helpers/auth.dart';

// Utilities:
import 'package:flash_chat_latest/utilities/constants.dart';

class MessagesHelper {
  final authHelper = Auth();

  // Constructor
  MessagesHelper() {
    authHelper.getCurrentUser();
  }

  Widget createMessageWidget(QueryDocumentSnapshot messageDocument) {
    final messageText = messageDocument.data()['text'];
    final messageSender = messageDocument.data()['sender'];
    Widget messageWidget;

    if (messageSender == authHelper.loggedInUser.email) {
      messageWidget = Bubble(
        margin: BubbleEdges.only(top: 10),
        elevation: 1,
        alignment: Alignment.topRight,
        nip: BubbleNip.rightBottom,
        color: Color.fromRGBO(225, 255, 199, 1.0),
        child: Text(messageText, textAlign: TextAlign.right),
      );
    } else {
      messageWidget = Bubble(
        margin: BubbleEdges.only(top: 10),
        elevation: 1,
        alignment: Alignment.topLeft,
        nip: BubbleNip.leftTop,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              messageSender,
              style: TextStyle(color: Colors.red.shade200),
            ),
            Text(
              messageText,
            ),
          ],
        ),
      );
    }

    return messageWidget;
  }

  Map<String, dynamic> createMessageData(String messageText) {
    Map<String, dynamic> messageData = {
      'text': messageText,
      'sender': authHelper.loggedInUser.email,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };

    return messageData;
  }
}
