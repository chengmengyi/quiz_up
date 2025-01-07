import 'package:flutter/material.dart';

class QpImg extends StatelessWidget{
  String img;
  double? width;
  double? height;
  BoxFit? fit;
  QpImg({
    required this.img,
    this.width,
    this.height,
    this.fit,
});

  @override
  Widget build(BuildContext context) {
    return Image.asset("qp_img/$img.webp",width: width,height: height,fit: fit??BoxFit.fill,);
  }

}