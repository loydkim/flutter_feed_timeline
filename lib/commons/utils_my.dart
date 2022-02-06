import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message,
    {Color backColor = Colors.black54}) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    duration: Duration(seconds: 2),
    backgroundColor: backColor,
  ));
}
