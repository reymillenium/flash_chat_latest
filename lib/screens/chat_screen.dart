// Packages:
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/bubble.dart';
import 'dart:async'; // Allows to use Timer

// Screens:
import 'package:flash_chat_latest/screens/login_screen.dart';

// Components:

// Helpers:
import 'package:flash_chat_latest/helpers/auth.dart';
import 'package:flash_chat_latest/helpers/messages_helper.dart';

// Utilities:
import 'package:flash_chat_latest/utilities/constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final authHelper = Auth();
  final messagesHelper = MessagesHelper();

  // User loggedInUser;
  String messageText;
  final TextEditingController _messageInputController = new TextEditingController();
  final _listViewScrollController = ScrollController();

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

  void getMessages() async {
    // QuerySnapshot messagesSnapshot = await _firestore.collection('messages').get();
    // List<QueryDocumentSnapshot> messagesDocuments = messagesSnapshot.docs;
    // messagesDocuments.forEach((messageDocument) {
    //   Map<String, dynamic> message = messageDocument.data();
    //   print(message['text']);
    // });
    //
    // for (var messageDocument in messagesDocuments) {
    //   Map<String, dynamic> message = messageDocument.data();
    //   // print(message);
    //   print(message['text']);
    // }
  }

  void messagesStream() async {
    await for (var messageSnapshot in _firestore.collection('messages').orderBy('created', descending: true).snapshots()) {
      for (var message in messageSnapshot.docs) {
        // print(message.data());
        print(message.data());
      }
    }
  }

  void scrollListViewSmoothly() {
    _listViewScrollController.animateTo(
      _listViewScrollController.position.maxScrollExtent,
      // duration: Duration(seconds: 1),
      duration: Duration(milliseconds: 500),
      // curve: Curves.fastOutSlowIn,
      curve: Curves.easeOut,
    );
  }

  void scrollListView() {
    _listViewScrollController.jumpTo(_listViewScrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    // After 1 second, it takes you to the bottom of the ListView
    Timer(
      Duration(seconds: 1),
      // () => _listViewScrollController.jumpTo(_listViewScrollController.position.maxScrollExtent),
      () => _listViewScrollController.animateTo(
        _listViewScrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFFAF6CF),
      //FAF6CF
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
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('created_at', descending: false).snapshots(),
              builder: (context, asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                } else if (asyncSnapshot.hasData) {
                  final messagesDocuments = asyncSnapshot.data.docs;

                  List<Widget> messageWidgets = [];
                  for (var messageDocument in messagesDocuments) {
                    Widget messageWidget = messagesHelper.createMessageWidget(messageDocument);
                    messageWidgets.add(messageWidget);
                  }
                  return Expanded(
                    child: ListView(
                      controller: _listViewScrollController,
                      reverse: false,
                      shrinkWrap: false,
                      padding: const EdgeInsets.all(12.0),
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: messageWidgets,
                    ),
                  );
                }
                return CircularProgressIndicator();
              },
            ),

            // Text input and Send button:
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.blue,
                      controller: _messageInputController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  // FlatButton(
                  TextButton(
                    onPressed: () async {
                      Map<String, dynamic> data = messagesHelper.createMessageData(messageText);
                      await _firestore.collection('messages').add(data);
                      _messageInputController.clear();
                      // scrollListView();
                      scrollListViewSmoothly();
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
