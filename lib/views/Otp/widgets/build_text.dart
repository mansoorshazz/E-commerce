import 'package:flutter/material.dart';

class BuildText extends StatelessWidget {
  BuildText({
    Key? key,
    required this.text,
    required this.fontWeight,
    required this.fontSize,
  }) : super(key: key);

  final String text;
  final FontWeight fontWeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
