import 'package:flutter/material.dart';

class Padddedbutton extends StatelessWidget {
  Padddedbutton(
      {required this.color, required this.text, required this.Onpressed});
  late final Color color;
  late final String text;
  final Function Onpressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: Onpressed(),
          minWidth: 200.0,
          height: 42.0,
          child: Text(text),
        ),
      ),
    );
  }
}
