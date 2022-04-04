import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grabup/AllText.dart';
import 'package:grabup/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token = "";

  @override
  void initState() {
    super.initState();
    openHomeScreen();
  }

  openHomeScreen() async {
    SharedPreferences.getInstance().then((value) async {
      if (value.getBool("isTokenExist") ?? false) {
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TabBarScreen()),
          );
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TabBarScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(color: WHITE),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/icon.png'),
                  Text(
                    APPNAME,
                    style: TextStyle(
                        color: LIME,
                        fontSize: 35,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .2),
                  CircularProgressIndicator(
                    backgroundColor: LIME,
                  ),
                ],
              ),
            )));
  }
}
