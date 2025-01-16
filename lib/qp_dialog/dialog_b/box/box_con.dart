import 'package:decimal/decimal.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/ad/ad_type.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/point/ad_point_id.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/progress/progress_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class BoxCon extends GetxController{
  var addNum=ValueUtils.instance.getBoxAddNum();
  @override
  void onInit() {
    super.onInit();
    PointUtils.instance.pointEvent(AppPointId.coin_pop,data: {"source_from":"box"});
  }
  clickDou(index){
    PointUtils.instance.pointEvent(AppPointId.coin_pop_c,data: {"source_from":"box"});
    AdUtils.instance.showAd(
      adType: AdType.reward,
      adPointId: AdPointId.kwrap_box_rv,
      closeAd: (){
        back();
        BSql.instance.updateUserMoney((Decimal.parse("$addNum")*Decimal.fromInt(2)).toDouble());
        ProgressUtils.instance.receiveBoxOrWheel(index);
      },
      failAd: (){

      }
    );
  }

  clickSingle(index){
    PointUtils.instance.pointEvent(AppPointId.coin_pop_close,data: {"source_from":"box"});
    AdUtils.instance.showAd(
      adType: AdType.interstitial,
      adPointId: AdPointId.kwrap_box_int,
      closeAd: (){
        _clickSingleResult(index);
      },
      failAd: (){
        _clickSingleResult(index);
      }
    );
  }

  _clickSingleResult(index){
    back();
    BSql.instance.updateUserMoney(addNum);
    ProgressUtils.instance.receiveBoxOrWheel(index);
  }
}