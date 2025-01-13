import 'package:decimal/decimal.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class OldUserSignCon extends GetxController{
  var signAddNum=ValueUtils.instance.getSignAddNum();

  clickDou(){
    AdUtils.instance.showAd(
      closeAd: (){
        back();
        var money=Decimal.parse("$signAddNum")*Decimal.fromInt(2);
        BSql.instance.updateUserMoney(money.toDouble());
        GuideUtils.instance.updateOldUserStep(OldUserStep.completed);
      }
    );
  }

  clickSingle(){
    AdUtils.instance.showAd(
        closeAd: (){
          back();
          BSql.instance.updateUserMoney(signAddNum);
          GuideUtils.instance.updateOldUserStep(OldUserStep.completed);
        }
    );
  }

  clickClose(){
    back();
    GuideUtils.instance.updateOldUserStep(OldUserStep.completed);
  }
}