import 'package:flutter/material.dart';
import 'package:quiz_up/utils/utils.dart';

class QpText extends StatelessWidget{
  String text;
  double size;
  String color;
  FontWeight? fontWeight;
  List<Shadow>? shadows;
  TextAlign? textAlign;
  TextOverflow? overflow;

  QpText({
    required this.text,
    required this.size,
    required this.color,
    this.shadows,
    this.fontWeight,
    this.textAlign,
    this.overflow,
});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color.toColor(),
        fontWeight: fontWeight,
        shadows: shadows,
        fontFamily: fontWeight==FontWeight.w800||fontWeight==FontWeight.w400?"qp":null,
        // fontFamily: "qp",
        overflow: overflow,
      ),
      textAlign: textAlign,
    );
  }
}