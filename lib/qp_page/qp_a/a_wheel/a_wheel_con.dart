import 'dart:async';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/utils/question/a_question_utils.dart';
import 'package:quiz_up/utils/utils.dart';

class AWheelCon extends GetxController{
  var currentWheelAngle=0.0,resultType="";
  Timer? _wheelTimer;
  List<String> typeList=[];

  @override
  void onInit() {
    super.onInit();
    _initTypeList();
  }

  start(){
    if(null!=_wheelTimer){
      return;
    }
    resultType="";
    var type = typeList.random();
    var angel = _getAngleByType(type);
    var totalAngel=1080+angel;
    currentWheelAngle=0;
    update(["wheel"]);
    _wheelTimer=Timer.periodic(const Duration(milliseconds: 1), (t){
      currentWheelAngle++;
      update(["wheel","type"]);
      if(currentWheelAngle>=totalAngel){
        _stop(type);
      }
    });
  }

  _stop(type)async{
    _wheelTimer?.cancel();
    resultType=type;
    update(["type"]);
    await Future.delayed(Duration(milliseconds: 800));
    _wheelTimer=null;
    QpRouters.toNamed(routersName: QpRouName.aQuestion,arguments: {"type":type});
    // toNamed(routersName: QpRouName.aQuestion,arguments: {"type":QuestionType.history});
  }

  int _getAngleByType(type){
    switch(type){
      case QuestionType.animal: return 0;
      case QuestionType.math: return -60;
      case QuestionType.dailyLife: return -120;
      case QuestionType.science: return -180;
      case QuestionType.history: return -240;
      case QuestionType.nature: return -300;
      default: return 0;
    }
  }

  String getRandomTypeByAngle(){
    if(null==_wheelTimer){
      return "Please Spin";
    }
    if(resultType.isNotEmpty){
      return resultType;
    }
    return currentWheelAngle%2==0?typeList.first:typeList.last;
  }

  clickClose(){
    if(null!=_wheelTimer){
      return;
    }
    QpRouters.back();
  }

  _initTypeList(){
    var index = QpRouters.getArguments()["index"];
    switch(index){
      case 0:
        typeList.add(QuestionType.math);
        typeList.add(QuestionType.animal);
        break;
      case 1:
        typeList.add(QuestionType.nature);
        typeList.add(QuestionType.science);
        break;
      case 2:
        typeList.add(QuestionType.history);
        typeList.add(QuestionType.dailyLife);
        break;
    }
  }

  @override
  void onClose() {
    _wheelTimer?.cancel();
    _wheelTimer=null;
    super.onClose();
  }
}