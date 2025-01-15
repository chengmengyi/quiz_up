import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:quiz_up/utils/ad/ad_utils.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class FirebaseUtils{
  static final FirebaseUtils _utils=FirebaseUtils();
  static FirebaseUtils get instance=>_utils;

  var _initSuccess=false,float_dis=10;
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
      _initSuccess=true;
    }catch(e){
      _initSuccess=false;
    }
  }

  getString(){
    if(!_initSuccess){
      return;
    }
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
  }
}