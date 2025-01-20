import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:quiz_up/utils/check_user/check_user_utils.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';

class CheckAppsflyer{
  AppsflyerSdk? _appsflyerSdk;

  initAppsflyer()async{
    _appsflyerSdk=AppsflyerSdk(AppsFlyerOptions(
        afDevKey: "qxH3wE6Gtt55drYjXkCLDC",
        appId: "6740134727",
        timeToWaitForATTUserAuthorization: 8,
        disableAdvertisingIdentifier: false,
        disableCollectASA: false,
        manualStart: true,
        showDebug: true,
    ));
    await _appsflyerSdk?.initSdk(registerConversionDataCallback: true);
    var s = await FlutterTbaInfo.instance.getDistinctId();
    _appsflyerSdk?.setCustomerUserId(s);
    _appsflyerSdk?.onInstallConversionData((res){
      "check user---> request af result-->$res".log();
      try{
        if(res["status"]=="success"){
          var status = res["payload"]["af_status"].toString();
          var isB = !status.contains("Organic");
          PointUtils.instance.pointEvent(AppPointId.adjust_suc,data: {"adj_user":isB?1:0});
          if(isB){
            if(appsflyerResult.get().isEmpty){
              PointUtils.instance.pointEvent(AppPointId.organic_to_buy);
              appsflyerResult.save(status);
            }
            CheckUserUtils.instance.delayCheckResult();
          }
        }
      }catch(e){

      }
    });

    "check user---> start request af".log();
    PointUtils.instance.pointEvent(AppPointId.adjust_req);
    _appsflyerSdk?.startSDK(
      onSuccess: (){
        print("kk===initAppsflyer=onSuccess");
      },
      onError: (code,msg){
        print("kk===initAppsflyer${code}==${msg}");
      }
    );
  }
}