import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart' as color;
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_up/bean/ad_bean.dart';
import 'package:quiz_up/bean/ad_result_bean.dart';
import 'package:quiz_up/qp_dialog/loading_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/utils/ad/ad_num_utils.dart';
import 'package:quiz_up/utils/ad/ad_type.dart';
import 'package:quiz_up/utils/ad/load_ad.dart';
import 'package:quiz_up/utils/ad/show_ad_listener.dart';
import 'package:quiz_up/utils/check_user/check_user_utils.dart';
import 'package:quiz_up/utils/firebase_utils.dart';
import 'package:quiz_up/utils/local_info.dart';
import 'package:quiz_up/utils/point/ad_point_id.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class AdUtils {
  static final AdUtils _utils=AdUtils();
  static AdUtils get instance=>_utils;

  LoadAd? _oneLoadAd;
  LoadAd? _twoLoadAd;
  var _adShowing=false;
  ShowAdListener? _showAdListener;

  initAdSetting()async{
    await AppLovinMAX.initialize(maxAdKey.base64());
    // if(kDebugMode){
    //   AppLovinMAX.showMediationDebugger();
    // }
    _setMaxListener();
    _oneLoadAd=LoadAd(one: true);
    _twoLoadAd=LoadAd(one: false);
  }

  _setMaxListener(){
    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (ad){
          _oneLoadAd?.loadAdSuccess(ad);
          _twoLoadAd?.loadAdSuccess(ad);
        },
        onAdLoadFailedCallback: (ad,error){
          _oneLoadAd?.loadAdFail(ad);
          _twoLoadAd?.loadAdFail(ad);
        },
        onAdDisplayedCallback: (ad){
          _adShowing=true;
          _deleteAdCache(ad.adUnitId);
          AdNumUtils.instance.updateTodayShow();
          _showAdListener?.showSuccess.call(ad,_getAdInfoBeanById(ad.adUnitId));
        },
        onAdDisplayFailedCallback: (ad,error){
          _adShowing=false;
          _deleteAdCache(ad.adUnitId);
          _loadAd(AdType.reward);
          _showAdListener?.showFail.call(ad);
        },
        onAdClickedCallback: (ad){
          AdNumUtils.instance.updateTodayClick();
        },
        onAdHiddenCallback: (ad){
          _adShowing=false;
          _loadAd(AdType.reward);
          _showAdListener?.closeAd.call();
        },
        onAdReceivedRewardCallback: (ad,reward){

        },
        onAdRevenuePaidCallback: (ad){
          _showAdListener?.onAdRevenuePaidCallback.call(ad,_getAdInfoBeanById(ad.adUnitId));
        },
      )
    );

    AppLovinMAX.setInterstitialListener(
      InterstitialListener(
        onAdLoadedCallback: (ad){
          _oneLoadAd?.loadAdSuccess(ad);
          _twoLoadAd?.loadAdSuccess(ad);
        },
        onAdLoadFailedCallback: (ad,error){
          _oneLoadAd?.loadAdFail(ad);
          _twoLoadAd?.loadAdFail(ad);
        },
        onAdDisplayedCallback: (ad){
          _adShowing=true;
          _deleteAdCache(ad.adUnitId);
          AdNumUtils.instance.updateTodayShow();
          _showAdListener?.showSuccess.call(ad,_getAdInfoBeanById(ad.adUnitId));
        },
        onAdDisplayFailedCallback: (ad,error){
          _adShowing=false;
          _deleteAdCache(ad.adUnitId);
          _loadAd(AdType.interstitial);
          _showAdListener?.showFail.call(ad);
        },
        onAdClickedCallback: (ad){
          AdNumUtils.instance.updateTodayClick();
        },
        onAdHiddenCallback: (ad){
          _adShowing=false;
          _loadAd(AdType.interstitial);
          _showAdListener?.closeAd.call();
        },
        onAdRevenuePaidCallback: (ad){
          _showAdListener?.onAdRevenuePaidCallback.call(ad,_getAdInfoBeanById(ad.adUnitId));
        },
      )
    );
  }

  showAd({
    required String adType,
    required AdPointId adPointId,
    required Function() closeAd,
    required Function() failAd,
    bool isLaunch=false,
  }){
    var checkShowAd = ValueUtils.instance.checkShowAd(adType);
    if(!isLaunch&&!checkShowAd){
      closeAd.call();
      return;
    }
    PointUtils.instance.pointEvent(AppPointId.kwrap_ad_chance,data: {"ad_pos_id":adPointId.name});
    var linkAddress = _showH5Ad();
    if(!isLaunch&&adType==AdType.interstitial&&linkAddress.isNotEmpty){
      PointUtils.instance.pointEvent(AppPointId.kwrap_ad_impression,data: {"ad_pos_id":adPointId.name});
      PointUtils.instance.adEvent(null, null, adPointId);
      QpRouters.toNamed(
        routersName: QpRouName.web,
        arguments: {"url":linkAddress},
        backCall: (map){
          closeAd.call();
        }
      );
      return;
    }
    var resultBean = _getCacheResultBean(adType);
    if(null==resultBean){
      _loadAd(AdType.reward);
      _loadAd(AdType.interstitial);
      PointUtils.instance.pointEvent(AppPointId.kwrap_ad_impression_fail,data: {"ad_pos_id":adPointId.name,"reason":"nocache"});
      if(isLaunch){
        closeAd.call();
      }else{
        QpRouters.showDialog(
          barrierColor: color.Colors.transparent,
          widget: LoadingDialog(
            dismiss: (){
              if(null==_getCacheResultBean(adType)){
                showToast("Advertisement display failed,please try again later");
              }else{
                _hasCacheShowAd(adType: adType, adPointId: adPointId, closeAd: closeAd, failAd: failAd);
              }
            },
          ),
        );
      }
      return;
    }

    _hasCacheShowAd(adType: adType, adPointId: adPointId, closeAd: closeAd, failAd: failAd);
  }

  _hasCacheShowAd({
    required String adType,
    required AdPointId adPointId,
    required Function() closeAd,
    required Function() failAd,
  }){
    _startShowAd(
      adType: adType,
      listener: ShowAdListener(
        showSuccess: (ad,bean){
          PointUtils.instance.adEvent(ad, bean, adPointId);
          PointUtils.instance.pointEvent(AppPointId.kwrap_ad_impression,data: {"ad_pos_id":adPointId.name});
          var watchNum = watchAdNum.get();
          watchAdNum.save(watchNum+1);
          var adLevel = lastAdLevel.get()+5;
          if((watchNum+1)>=adLevel){
            PointUtils.instance.pointEvent(AppPointId.cash_ad_detail,data: {"ad_from":adLevel});
            lastAdLevel.save(adLevel);
          }
        },
        showFail: (ad){
          PointUtils.instance.pointEvent(AppPointId.kwrap_ad_impression_fail,data: {"ad_pos_id":adPointId.name,"reason":"showfail"});
          failAd.call();
        },
        closeAd: (){
          closeAd.call();
        },
        onAdRevenuePaidCallback: (ad,bean){
          CheckUserUtils.instance.uploadAfRevenue(ad, bean?.balemcur??"", adPointId);
        },
      ),
    );
  }

  _startShowAd({
    required String adType,
    required ShowAdListener listener,
  })async{
    _showAdListener=listener;
    if(_adShowing){
      "quiz up ad--->ad showing".log();
      _showAdListener?.showFail.call(null);
      return;
    }
    var resultBean = _getCacheResultBean(adType);
    if(null!=resultBean){
      "quiz up ad--->start show ad --->type:$adType--->${resultBean.adBean.toString()}".log();
      if(adType==AdType.reward){
        if(await AppLovinMAX.isRewardedAdReady(resultBean.adBean.balemcur??"")==true){
          AppLovinMAX.showRewardedAd(resultBean.adBean.balemcur??"");
        }else{
          "quiz up ad--->$adType not Ready".log();
          _deleteAdCache(resultBean.adBean.balemcur??"");
          _showAdListener?.showFail.call(null);
          _loadAd(adType);
        }
      }else if(adType==AdType.interstitial){
        if(await AppLovinMAX.isInterstitialReady(resultBean.adBean.balemcur??"")==true){
          AppLovinMAX.showInterstitial(resultBean.adBean.balemcur??"");
        }else{
          "quiz up ad--->$adType not Ready".log();
          _deleteAdCache(resultBean.adBean.balemcur??"");
          _showAdListener?.showFail.call(null);
          _loadAd(adType);
        }
      }
    }else{
      _showAdListener?.showFail.call(null);
    }
  }

  _loadAd(String adType){
    _oneLoadAd?.loadAd(adType);
    _twoLoadAd?.loadAd(adType);
  }

  _deleteAdCache(String id){
    _oneLoadAd?.deleteCache(id);
    _twoLoadAd?.deleteCache(id);
  }
  
  AdResultBean? _getCacheResultBean(String adType){
    var oneResult = _oneLoadAd?.getCacheAd(adType);
    if(null!=oneResult){
      return oneResult;
    }
    var twoResult = _twoLoadAd?.getCacheAd(adType);
    if(null!=twoResult){
      return twoResult;
    }
    return null;
  }

  AdBean? _getAdInfoBeanById(String id){
    var adBean = _oneLoadAd?.getAdInfoBeanById(id);
    adBean ??= _twoLoadAd?.getAdInfoBeanById(id);
    return adBean;
  }

  updateAdConfigData(){
    _oneLoadAd?.updateConfigData();
    _twoLoadAd?.updateConfigData();
  }

  bool checkAdShowing()=>_adShowing;

  String _showH5Ad(){
    if(FirebaseUtils.instance.afd_ad.isEmpty){
      return "";
    }
    try{
      var json = jsonDecode(FirebaseUtils.instance.afd_ad);
      var linkAddress = json["link_adress"] as String;
      var point = json["ad_point"] as int;
      if(linkAddress.isEmpty){
        return "";
      }
      if(Random().nextInt(100)<point){
        return linkAddress;
      }
      return "";
    }catch(e){
      return "";
    }
  }
}