import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationGenerator extends StatefulWidget {
  @override
  _NotificationGeneratorState createState() => _NotificationGeneratorState();
}

class _NotificationGeneratorState extends State<NotificationGenerator> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Generate"),
          onPressed: () {},
        ),
      ),
    );
  }
}
