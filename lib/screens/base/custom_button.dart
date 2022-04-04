import 'package:flutter/material.dart';
import 'package:grabup/main.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final double margin;
  CustomButton(
      {@required this.buttonText, @required this.onPressed, this.margin = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: onPressed == null ? LIGHT_GREY : LIME,
          minimumSize: Size(MediaQuery.of(context).size.width, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(buttonText,
            style: TextStyle(
                color: WHITE, fontWeight: FontWeight.w700, fontSize: 17)),
      ),
    );
  }
}
