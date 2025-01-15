import 'package:applovin_max/applovin_max.dart';
import 'package:quiz_up/bean/ad_bean.dart';
import 'package:quiz_up/bean/ad_result_bean.dart';
import 'package:quiz_up/utils/ad/ad_num_utils.dart';
import 'package:quiz_up/utils/ad/ad_type.dart';
import 'package:quiz_up/utils/ad/base_ad.dart';
import 'package:quiz_up/utils/utils.dart';

class LoadAd extends BaseAd{
  bool one;

  final List<AdBean> _intList=[];
  final List<AdBean> _rvList=[];
  final List<String> _loadingList=[];
  final Map<String,AdResultBean> _resultMap={};

  LoadAd({required this.one}){
    _intList.addAll(getAdList(AdType.interstitial, one));
    _rvList.addAll(getAdList(AdType.reward, one));
    loadAd(AdType.reward);
    loadAd(AdType.interstitial);
  }


  loadAd(String type) {
    if(AdNumUtils.instance.notLoadAd()){
      "quiz up ad--->one:$one--->show or click max, not load ad".log();
      return;
    }
    if(_loadingList.contains(type)){
      "quiz up ad--->one:$one--->$type is loading".log();
      return;
    }
    if(null!=getCacheAd(type)){
      "quiz up ad--->one:$one--->$type has cache".log();
      return;
    }

    var list = _getListByType(type);
    if(list.isEmpty){
      "quiz up ad--->one:$one--->$type list is empty".log();
      return;
    }
    _loadingList.add(type);
    _startLoadAd(type, list.first);
  }

  _startLoadAd(String type, AdBean bean){
    "quiz up ad--->one:$one--->start load $type ad ,info=>${bean.toString()}".log();
    if(type==AdType.reward){
      AppLovinMAX.loadRewardedAd(bean.balemcur??"");
    }else if(type==AdType.interstitial){
      AppLovinMAX.loadInterstitial(bean.balemcur??"");
    }
  }

  loadAdSuccess(MaxAd ad){
    var adBean = getAdInfoBeanById(ad.adUnitId);
    if(null!=adBean){
      "quiz up ad--->one:$one--->${ad.adUnitId} load ad success".log();
      _loadingList.remove(adBean.mtuskwlf);
      _resultMap[adBean.mtuskwlf??""]=AdResultBean(loadTime: DateTime.now().millisecondsSinceEpoch, adBean: adBean);
    }
  }

  loadAdFail(String id){
    var adBean = getAdInfoBeanById(id);
    if(null!=adBean){
      "quiz up ad--->one:$one--->$id load ad fail".log();
      var nextAdBean = _getNextAdBean(id);
      if(null!=nextAdBean){
        _startLoadAd(adBean.mtuskwlf??"",nextAdBean);
      }else{
        "quiz up ad--->one:$one--->no next ad, end load".log();
        _loadingList.remove(adBean.mtuskwlf);
        loadAd(adBean.mtuskwlf??"");
      }
    }
  }

  AdBean? _getNextAdBean(String id){
    var indexWhere = _rvList.indexWhere((value)=>value.balemcur==id);
    if(indexWhere>=0&&_rvList.length>indexWhere+1){
      return _rvList[indexWhere+1];
    }

    var indexWhere2 = _intList.indexWhere((value)=>value.balemcur==id);
    if(indexWhere2>=0&&_intList.length>indexWhere2+1){
      return _intList[indexWhere2+1];
    }
    return null;
  }
  
  AdBean? getAdInfoBeanById(String id){
    var indexWhere = _intList.indexWhere((value)=>value.balemcur==id);
    if(indexWhere>=0){
      return _intList[indexWhere];
    }
    var indexWhere2 = _rvList.indexWhere((value)=>value.balemcur==id);
    if(indexWhere2>=0){
      return _rvList[indexWhere2];
    }
    return null;
  }
  
  List<AdBean> _getListByType(String type)=>type==AdType.interstitial?_intList:_rvList;

  AdResultBean? getCacheAd(String type){
    var bean = _resultMap[type];
    if(null!=bean){
      var expired = DateTime.now().millisecondsSinceEpoch-bean.loadTime>((bean.adBean.neigksge??3000)*1000);
      if(expired){
        deleteCache(bean.adBean.balemcur);
        return null;
      }
      return bean;
    }
    return null;
  }

  deleteCache(String? adId){
    _resultMap.removeWhere((key,value)=>value.adBean.balemcur==adId);
  }

  updateConfigData(){
    _intList.clear();
    _rvList.clear();
    _intList.addAll(getAdList(AdType.interstitial, one));
    _rvList.addAll(getAdList(AdType.reward, one));
  }
}