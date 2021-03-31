// Packages:
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/bubble.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // authHelper.handleSignOut();
                // Navigator.pushNamed(context, LoginScreen.id);
                messagesStream();
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
                    final messageText = messageDocument.data()['text'];
                    final messageSender = messageDocument.data()['sender'];

                    Widget messageWidget;
                    if (messageSender == authHelper.loggedInUser.email) {
                      messageWidget = Bubble(
                        margin: BubbleEdges.only(top: 10),
                        nip: BubbleNip.rightTop,
                        alignment: Alignment.topRight,
                        color: Color.fromRGBO(225, 255, 199, 1.0),
                        child: Text(messageText, textAlign: TextAlign.right),
                      );
                    } else {
                      messageWidget = Bubble(
                        margin: BubbleEdges.only(top: 10),
                        nip: BubbleNip.leftTop,
                        alignment: Alignment.topLeft,
                        child: Text(messageText),
                      );
                    }

                    messageWidgets.add(messageWidget);
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: messageWidgets,
                  );
                }
                return CircularProgressIndicator();
              },
            ),
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
                      Map<String, dynamic> data = {
                        'text': messageText,
                        'sender': authHelper.loggedInUser.email,
                        'created_at': FieldValue.serverTimestamp(),
                        'updated_at': FieldValue.serverTimestamp(),
                      };
                      await _firestore.collection('messages').add(data);

                      _controller.clear();
                      // getMessages();
                      // messagesStream();
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
