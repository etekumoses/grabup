import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grabup/main.dart';

class RealTimeTesting extends StatefulWidget {
  @override
  _RealTimeTestingState createState() => _RealTimeTestingState();
}

class _RealTimeTestingState extends State<RealTimeTesting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: LIME,
          ),
          onPressed: () async{
            FirebaseDatabase.instance.reference().child("testing").set({
              "key" : "value",
            });
          }, child: Container(),
        ),
      ),
    );
  }
}
