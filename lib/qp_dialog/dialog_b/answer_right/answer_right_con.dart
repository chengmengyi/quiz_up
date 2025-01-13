import 'package:decimal/decimal.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/answer_right/answer_right_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';

class AnswerRightCon extends GetxController{

  clickDou(double addNum,Function() dismiss,AnswerRightTyp type){
    AdUtils.instance.showAd(
      closeAd: (){
        back();
        BSql.instance.updateUserMoney((Decimal.parse("$addNum")*Decimal.fromInt(2)).toDouble());
        dismiss.call();
      }
    );
  }

  clickSingle(double addNum,Function() dismiss,AnswerRightTyp type){
    AdUtils.instance.showAd(
        closeAd: (){
          back();
          BSql.instance.updateUserMoney(addNum);
          dismiss.call();
        }
    );
  }

  clickClose(Function() dismiss){
    back();
    dismiss.call();
  }
}