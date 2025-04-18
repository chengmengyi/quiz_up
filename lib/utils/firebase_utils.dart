import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/ad/h5_ad_utils.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class FirebaseUtils{
  static final FirebaseUtils _utils=FirebaseUtils();
  static FirebaseUtils get instance=>_utils;

  var float_dis=10,qu_af_on="1",afd_ad="",h5CloseBtnShowTime=0,homeH5BtnShow="1";
  FirebaseRemoteConfig? _firebaseRemoteConfig;

  checkWorkNet(){
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if(!result.contains(ConnectivityResult.none)){
        _initFirebase();
        AdUtils.instance.initAdSetting();
      }
    });
  }

  _initFirebase()async{
    try{
      await Firebase.initializeApp();
      _firebaseRemoteConfig=FirebaseRemoteConfig.instance;
      await _firebaseRemoteConfig?.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(seconds: 1),
      ));
      await _firebaseRemoteConfig?.fetchAndActivate();
      getString();
    }catch(e){
    }
  }

  getString(){
    var floatTime = _firebaseRemoteConfig?.getString("float_dis")??"";
    if(floatTime.isNotEmpty){
      float_dis=floatTime.toInt(defaultInt: 10);
    }
    var qt_number = _firebaseRemoteConfig?.getString("qt_number")??"";
    if(qt_number.isNotEmpty&&valueConfig.get().isEmpty){
      valueConfig.save(qt_number);
      ValueUtils.instance.initValue();
    }
    var kwrap_ad_config = _firebaseRemoteConfig?.getString("kwrap_ad_config")??"";
    if(kwrap_ad_config.isNotEmpty&&adConfig.get()!=kwrap_ad_config){
      adConfig.save(kwrap_ad_config);
      AdUtils.instance.updateAdConfigData();
    }

    var afOn = _firebaseRemoteConfig?.getString("qu_af_on")??"";
    if(afOn.isNotEmpty){
      qu_af_on=afOn;
    }

    var afd = _firebaseRemoteConfig?.getString("afd_ad")??"";
    "quiz up ad--->afd====$afd".log();
    if(afd.isNotEmpty){
      afd_ad=afd;
    }
    var ad_ecpm = _firebaseRemoteConfig?.getString("ad_ecpm")??"";
    if(ad_ecpm.isNotEmpty){
      H5AdUtils.instance.initH5AdBean(ad_ecpm);
    }
    var h5_ad_close=_firebaseRemoteConfig?.getString("h5_ad_close")??"";
    if(h5_ad_close.isNotEmpty){
      h5CloseBtnShowTime=h5_ad_close.toInt();
    }
    var quiz_h5=_firebaseRemoteConfig?.getString("quiz_h5")??"";
    if(quiz_h5.isNotEmpty){
      homeH5BtnShow=quiz_h5;
    }
  }
}