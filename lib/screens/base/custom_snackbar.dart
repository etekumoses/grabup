import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(String message, BuildContext context,
    {bool isError = true}) {
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   backgroundColor: isError ? Colors.black : Colors.green,
  //   content: Text(message),
  //   duration: Duration(milliseconds: 600),

  // ));
  Flushbar(
    title: isError ? 'Error' : 'Success',
    message: message,
    flushbarPosition: FlushbarPosition.BOTTOM,
    icon: Icon(
      Icons.error,
      size: 28,
      color: Colors.white,
    ),
    leftBarIndicatorColor: Theme.of(context).primaryColor,
    duration: Duration(seconds: 2),
  )..show(context);
}
