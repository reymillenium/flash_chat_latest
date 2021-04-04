// Packages:
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Allows to use FieldValue, etc
import 'package:bubble/bubble.dart';
import 'package:intl/intl.dart'; // Allows to use DateFormat

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

  List<Widget> createMessageWidgets(List<QueryDocumentSnapshot> messagesDocuments) {
    List<Widget> messageWidgets = [];
    // for (var messageDocument in messagesDocuments) {
    //   Widget messageWidget = createMessageWidget(messageDocument, false);
    //   messageWidgets.add(messageWidget);
    // }
    // print('messagesDocuments = ${messagesDocuments}');

    for (int i = 0; i < messagesDocuments.length; i++) {
      bool isCloseToNext = false;
      QueryDocumentSnapshot currentMessageDocument = messagesDocuments[i];
      String currentMessageSender = currentMessageDocument.data()['sender'];
      // DateTime currentMessageDate = currentMessageDocument.data()['created_at'].toDate();
      DateTime currentMessageDate = currentMessageDocument.data()['created_at'] == null ? DateTime.now() : currentMessageDocument.data()['created_at'].toDate();

      if (i < messagesDocuments.length - 1) {
        QueryDocumentSnapshot nextMessageDocument = messagesDocuments[i + 1];
        String nextMessageSender = nextMessageDocument.data()['sender'];
        // DateTime nextMessageDate = nextMessageDocument.data()['created_at'].toDate();
        DateTime nextMessageDate = nextMessageDocument.data()['created_at'] == null ? DateTime.now() : nextMessageDocument.data()['created_at'].toDate();
        if ((currentMessageSender == nextMessageSender) && (nextMessageDate.difference(currentMessageDate).inSeconds <= 60)) {
          isCloseToNext = true;
        }
      }

      Widget messageWidget = createMessageWidget(currentMessageDocument, isCloseToNext);
      messageWidgets.add(messageWidget);
    }

    return messageWidgets;
  }

  Widget createMessageWidget(QueryDocumentSnapshot messageDocument, bool isCloseToNext) {
    final messageSender = messageDocument.data()['sender'];
    Widget messageWidget;

    if (messageSender == authHelper.loggedInUser.email) {
      messageWidget = createOurMessageBubble(messageDocument, isCloseToNext);
    } else {
      messageWidget = createExternalMessageBubble(messageDocument, isCloseToNext);
    }

    return messageWidget;
  }

  Bubble createOurMessageBubble(QueryDocumentSnapshot messageDocument, bool isCloseToNext) {
    final messageText = messageDocument.data()['text'];
    RichText richTextDataLabel = createRichTextDataLabel(messageDocument);

    return Bubble(
      margin: BubbleEdges.only(top: 10),
      elevation: 1,
      alignment: Alignment.topRight,
      nip: (isCloseToNext ? BubbleNip.no : BubbleNip.rightBottom),
      color: Color.fromRGBO(225, 255, 199, 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            // color: Colors.blue,
            child: Text(messageText, textAlign: TextAlign.justify),
          ),
          // container,
          richTextDataLabel,
        ],
      ),
    );
  }

  Bubble createExternalMessageBubble(QueryDocumentSnapshot messageDocument, bool isCloseToNext) {
    final messageText = messageDocument.data()['text'];
    final messageSender = messageDocument.data()['sender'];
    RichText richTextDataLabel = createRichTextDataLabel(messageDocument);

    return Bubble(
      margin: BubbleEdges.only(top: 10),
      elevation: 1,
      alignment: Alignment.topLeft,
      nip: (isCloseToNext ? BubbleNip.no : BubbleNip.leftTop),
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
          richTextDataLabel,
        ],
      ),
    );
  }

  RichText createRichTextDataLabel(QueryDocumentSnapshot messageDocument) {
    return RichText(
      text: new TextSpan(children: [
        TextSpan(
          text: messageDocument.data()["created_at"] != null ? DateFormat.MMMd().add_jm().format(messageDocument.data()["created_at"].toDate()).toString() : "",
          style: TextStyle(
            color: Colors.green,
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextSpan(
          text: '   ',
          style: TextStyle(
            color: Colors.green,
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        WidgetSpan(
            child: messageDocument.data()['isRead'] == false
                ? Icon(
                    Icons.done,
                    color: Colors.greenAccent,
                    size: 15,
                  )
                : Icon(
                    Icons.done_all,
                    color: Colors.green,
                    size: 15,
                  )),
      ]),
    );
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
