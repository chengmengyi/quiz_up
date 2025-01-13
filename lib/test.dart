import 'package:flutter/material.dart';
import 'package:quiz_up/bean/b_user_info.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/utils/progress/progress_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';

class Test extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: TextButton(onPressed: ()async{
        // BSql.instance.bUserInfo?.answerRightNum=0;
        // BSql.instance.bUserInfo?.answerIndex=0;
        // BSql.instance.bUserInfo?.answerNum=0;
        // await ProgressUtils.instance.getProgressList();
        toNamed(routersName: QpRouName.bQuiz);
      }, child: Text("dianji")),
    ),
  );
}