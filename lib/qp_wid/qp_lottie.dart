import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class QpLottie extends StatelessWidget{
  String name;
  String? ext;
  double? width;
  double? height;

  QpLottie({
    required this.name,
    this.ext,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) => Lottie.asset("qp_lottie/$name.${ext??"zip"}",width: width,height: height,fit: BoxFit.fill);
}