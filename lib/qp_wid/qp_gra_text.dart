import 'package:flutter/material.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';

class QpGraText extends StatelessWidget{
  String text;
  double size;
  List<Color> colors;
  FontWeight? fontWeight;
  AlignmentGeometry? begin;
  AlignmentGeometry? end;
  List<Shadow>? shadows;
  TextAlign? textAlign;
  TextOverflow? overflow;

  QpGraText({
    required this.text,
    required this.size,
    required this.colors,
    this.fontWeight,
    this.begin,
    this.end,
    this.shadows,
    this.textAlign,
    this.overflow,
  });


  @override
  Widget build(BuildContext context) => ShaderMask(
    shaderCallback: (rect) {
      return LinearGradient(
        begin: begin??Alignment.topCenter,
        end: end??Alignment.bottomCenter,
        colors: colors,
      ).createShader(rect);
    },
    child: QpText(
      text: text,
      size: size,
      color: "#FFFFFF",
      fontWeight: fontWeight,
      shadows: shadows,
      overflow: overflow,
    ),
  );
}