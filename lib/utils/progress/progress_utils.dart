import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_up/bean/progress_bean.dart';
import 'package:quiz_up/utils/question/b_question_util.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';

class ProgressUtils{
  static final ProgressUtils _utils=ProgressUtils();
  static ProgressUtils get instance=>_utils;
  final List<int> _receivedIndexList=[];
  final List<ProgressBean> progressList=[];

  getProgressList()async{
    var list = await BSql.instance.queryReceivedIndexList();
    _receivedIndexList.addAll(list);
    var quizNum = BQuestionUtil.instance.getAllQuizNum();
    progressList.clear();
    for(int index=0;index<quizNum;index++){
      if(index==0){
        progressList.add(ProgressBean(progressType: ProgressType.empty, received: false));
      }else{
        var box=index==1||index==5||(index-1)%4==0;
        var wheel=index==9||(index-9)%12==0;
        progressList.add(ProgressBean(progressType: wheel?ProgressType.wheel:box?ProgressType.box:ProgressType.empty, received: _receivedIndexList.contains(index)));
      }
    }
  }

  updateProgressList(){

  }

  double getProgress(double maxWidth){
    var answerNum = BSql.instance.bUserInfo?.answerNum??0;
    var width=0.0;
    for(int index=0;index<answerNum;index++){
      var bean = progressList[index];
      width+=(bean.progressType==ProgressType.empty?10.w:60.w);
    }
    var d = width/maxWidth;
    if(d<=0){
      return 0.0;
    }else if(d>=1){
      return 1.0;
    }
    return d;
  }
}