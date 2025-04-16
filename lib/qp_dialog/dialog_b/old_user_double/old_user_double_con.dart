import 'package:decimal/decimal.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/ad/ad_type.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';
import 'package:quiz_up/utils/point/ad_point_id.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class OldUserDoubleCon extends GetxController{
  var wheelAddNum=0,signAddNum=ValueUtils.instance.getSignAddNum();
  
  @override
  void onInit() {
    super.onInit();
    PointUtils.instance.pointEvent(AppPointId.daily_pop,data: {"source_from":"wheel"});
  }
  
  clickDou(){
    PointUtils.instance.pointEvent(AppPointId.daily_pop_c,data: {"source_from":"wheel"});
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adPointId: AdPointId.kwrap_olduser_wheel_rv,
      closeAd: (){
        QpRouters.back();
        var money=(Decimal.parse("$wheelAddNum")+Decimal.parse("$signAddNum"))*Decimal.fromInt(2);
        BSql.instance.updateUserMoney(money.toDouble());
        GuideUtils.instance.updateOldUserStep(OldUserStep.completed);
      },
      failAd: (){

      }
    );
  }

  clickSingle(){
    AdUtils.instance.showAd(
      adType: AdType.interstitial,
      adPointId: AdPointId.kwrap_olduser_wheel_int,
      closeAd: (){
        _clickSingleResult();
      },
      failAd: (){
        _clickSingleResult();
      }
    );
  }

  _clickSingleResult(){
    QpRouters.back();
    var money=Decimal.parse("$wheelAddNum")+Decimal.parse("$signAddNum");
    BSql.instance.updateUserMoney(money.toDouble());
    GuideUtils.instance.updateOldUserStep(OldUserStep.completed);
  }

  clickClose(){
    QpRouters.back();
    GuideUtils.instance.updateOldUserStep(OldUserStep.completed);
  }
}