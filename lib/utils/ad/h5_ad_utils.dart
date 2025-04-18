import 'dart:convert';

import 'package:applovin_max/applovin_max.dart';
import 'package:quiz_up/bean/h5_ad_bean.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';

class H5AdUtils{
  static final H5AdUtils _instance = H5AdUtils();
  static H5AdUtils get instance => _instance;

  H5AdBean? _h5adBean;

  initH5AdBean(String json){
    try{
      var j = jsonDecode(json);
      _h5adBean=H5AdBean(adEcpm: j["ad_ecpm"], adChance: j["ad_chance"]);
    }catch(e){

    }
  }

  test(){
    // _h5adBean=H5AdBean(adEcpm: 1, adChance: 1);
    // print("kk====${_h5adBean?.adEcpm}====${_h5adBean?.adChance}");

    h5Ecpm.save([]);
  }

  addEcpmList(MaxAd? ad){
    if(null==_h5adBean){
      return;
    }
    var list = h5Ecpm.get();
    list.add(ad?.revenue??0.0);
    h5Ecpm.save(list);
  }

  bool checkShowH5Ad(){
    if(null==_h5adBean){
      return false;
    }
    var list = h5Ecpm.get();
    print("kk===checkShowH5Ad====${list.length}");
    if(list.length<(_h5adBean?.adChance??0)){
      return false;
    }
    h5Ecpm.save([]);
    var average = _calculateAverage(list);
    print("kk===checkShowH5Ad====${list.length}=====${average}===");
    return _calculateAverage(list)<(_h5adBean?.adEcpm??0.0);
  }

  double _calculateAverage(List<double> numbers) {
    if (numbers.isEmpty) {
      return 0;
    }
    double sum = numbers.reduce((value, element) => value + element);
    return sum / numbers.length;
  }
}