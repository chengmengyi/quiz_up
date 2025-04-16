import 'package:decimal/decimal.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/answer_right/answer_right_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/ad/ad_type.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/cash_task/cash_task_utils.dart';
import 'package:quiz_up/utils/cash_task/task_type.dart';
import 'package:quiz_up/utils/point/ad_point_id.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';

class AnswerRightCon extends GetxController{

  clickDou(double addNum,Function() dismiss,AnswerRightTyp type){
    if(type==AnswerRightTyp.wheel){
      CashTaskUtils.instance.updateCashTask(TaskType.box);
    }
    PointUtils.instance.pointEvent(AppPointId.coin_pop_c,data: {"source_from":type==AnswerRightTyp.quiz?"quiz":"wheel"});
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adPointId: type==AnswerRightTyp.quiz?AdPointId.kwrap_quiz_rv:AdPointId.kwrap_wheel_rv,
      closeAd: (){
        QpRouters.back();
        BSql.instance.updateUserMoney((Decimal.parse("$addNum")*Decimal.fromInt(2)).toDouble());
        dismiss.call();
      },
      failAd: (){

      }
    );
  }

  clickSingle(double addNum,Function() dismiss,AnswerRightTyp type){
    if(type==AnswerRightTyp.wheel){
      CashTaskUtils.instance.updateCashTask(TaskType.box);
    }
    PointUtils.instance.pointEvent(AppPointId.coin_pop_close,data: {"source_from":type==AnswerRightTyp.quiz?"quiz":"wheel"});
    AdUtils.instance.showAd(
      adType: AdType.interstitial,
      adPointId: type==AnswerRightTyp.quiz?AdPointId.kwrap_quiz_int:AdPointId.kwrap_wheel_int,
      closeAd: (){
        _clickSingleResult(addNum, dismiss);
      },
      failAd: (){
        _clickSingleResult(addNum, dismiss);
      }
    );
  }

  _clickSingleResult(double addNum,Function() dismiss){
    QpRouters.back();
    BSql.instance.updateUserMoney(addNum);
    dismiss.call();
  }

  clickClose(Function() dismiss){
    QpRouters.back();
    dismiss.call();
  }
}