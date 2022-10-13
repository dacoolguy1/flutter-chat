import 'package:flutter/material.dart';
import 'package:flutter_chart/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
//final _auth = FirebaseAuth.instance; //Create an instance (object) of auth

final _firestore = FirebaseFirestore.instance;
late User loggedinUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Mesagetextcontrolelr = TextEditingController();
  final _auth = FirebaseAuth.instance; //Create an instance (object) of auth

  late String messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser;

    try {
      if (user != null) {
        loggedinUser = user;
        print(loggedinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<void> getMessage() async {
//    final messag = await _firestore.collection('messages').get();
  //  final messages = messag.docs.map((doc) => doc.data()).toList();
  //for (var message in messages) {
  //     print(message);
  // }
  //}
  // void messagesStream() async {
  // await for (var snapshot in _firestore.collection('messages').snapshots()) {
  // for (var message in snapshot.docs) {
  // print(message.data);
  //}
  //}
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
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
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: Mesagetextcontrolelr,
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //Implement send functionality.
                      // messageTest = loggedUsr.email
                      _firestore.collection('messages').add(
                          {'text': messageText, 'sender': loggedinUser.email});
                      //getMessage();
                      //messagesStream();
                      Mesagetextcontrolelr.clear();
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

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.blueAccent),
          );
        }

        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messagWidget = [];
        for (var message in messages) {
          //var data = message.data();

          final messageText = message['text'];
          final messagesender = message['sender'];
          final currentuser = loggedinUser.email;
          if (currentuser == messagesender) {}
          final messageBubble = MessageBubble(
            text: messageText,
            sender: messagesender,
            isme: currentuser == messagesender,
          );
          messagWidget.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messagWidget,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text, required this.sender, required this.isme});
  final String text;
  final String sender;
  final bool isme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
            borderRadius: isme
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
            elevation: 5,
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Text(
                '$text ',
                style: TextStyle(
                    fontSize: 15, color: isme ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
