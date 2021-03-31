// Packages:
import 'package:flash_chat_latest/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Screens:

// Components:

// Helpers:
import 'package:flash_chat_latest/helpers/auth.dart';

// Utilities:
import 'package:flash_chat_latest/utilities/constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final authHelper = Auth();
  // User loggedInUser;
  String messageText;
  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    authHelper.getCurrentUser();
  }

  // void getCurrentUser() async {
  //   try {
  //     final user = await _auth.currentUser;
  //     // print('user = $user');
  //     if (user != null) {
  //       loggedInUser = user;
  //       print('loggedInUser.email = ${loggedInUser.email}');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // void getMessages() async {
  //   QuerySnapshot messagesSnapshot = await _firestore.collection('messages').get();
  //   List<QueryDocumentSnapshot> messagesDocuments = messagesSnapshot.docs;
  //   messagesDocuments.forEach((messageDocument) {
  //     Map<String, dynamic> message = messageDocument.data();
  //     // print(message);
  //     print(message['text']);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                authHelper.handleSignOut();
                Navigator.pushNamed(context, LoginScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  // FlatButton(
                  TextButton(
                    onPressed: () async {
                      Map<String, dynamic> data = {'text': messageText, 'sender': authHelper.loggedInUser.email};
                      await _firestore.collection('messages').add(data);
                      _controller.clear();
                      // getMessages();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
