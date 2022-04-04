import 'package:flutter/material.dart';

import '../main.dart';

class PlaceHolderScreen extends StatelessWidget {
  final String iconPath;
  final String message;
  final String description;

  PlaceHolderScreen({this.iconPath, this.message, this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREY_SCREEN_BG,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 100,
              width: 100,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              message,
              style: TextStyle(
                  color: BLACK, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: LIGHT_GREY_TEXT,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
