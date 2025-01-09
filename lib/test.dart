import 'package:flutter/material.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';

class Test extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: TextButton(onPressed: (){
        toNamed(routersName: QpRouName.bQuiz);
      }, child: Text("dianji")),
    ),
  );
}