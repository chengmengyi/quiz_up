import 'package:decimal/decimal.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/progress/progress_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class BoxCon extends GetxController{
  var addNum=ValueUtils.instance.getBoxAddNum();

  clickDou(index){
    AdUtils.instance.showAd(
        closeAd: (){
          back();
          BSql.instance.updateUserMoney((Decimal.parse("$addNum")*Decimal.fromInt(2)).toDouble());
          ProgressUtils.instance.receiveBoxOrWheel(index);
        }
    );
  }

  clickSingle(index){
    AdUtils.instance.showAd(
        closeAd: (){
          back();
          BSql.instance.updateUserMoney(addNum);
          ProgressUtils.instance.receiveBoxOrWheel(index);
        }
    );
  }
}