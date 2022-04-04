import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'notificationHelper.dart';

class TestingNotification extends StatefulWidget {
  @override
  _TestingNotificationState createState() => _TestingNotificationState();
}

class _TestingNotificationState extends State<TestingNotification> {
  MyNotificationHelper myNotificationHelper = MyNotificationHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Send Notification"),
          onPressed: () async {
            sendNotification(
                "Manveer", "Message", await firebaseMessaging.getToken());
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> sendNotification(
      String userName, String message, String token) async {
    await firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: false);

    await http
        .post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': message, 'title': userName},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    )
        .then((value) {
      print("\n\nMessage sent : ${value.body.toString()}");
    });

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    return completer.future;
  }
}
