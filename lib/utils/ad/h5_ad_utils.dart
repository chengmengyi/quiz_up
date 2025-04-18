import 'dart:convert';

import 'package:applovin_max/applovin_max.dart';
import 'package:quiz_up/bean/h5_ad_bean.dart';
import 'package:quiz_up/utils/storage/storage_event.dart';
import 'package:quiz_up/utils/utils.dart';

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

    // h5Ecpm.save([]);

    // var list = _getEcpmList();
    // list.add(0.33);
    // h5Ecpm.save(list.map((e) => e.toString()).join('|'));
    // print("kkkkkk===${h5Ecpm.get()}");
  }

  addEcpmList(MaxAd? ad){
    if(null==_h5adBean){
      return;
    }
    var list = _getEcpmList();
    list.add(ad?.revenue??0.0);
    h5Ecpm.save(list.map((e) => e.toString()).join('|'));
  }

  bool checkShowH5Ad(){
    if(null==_h5adBean){
      return false;
    }
    var list = _getEcpmList();
    print("kk===checkShowH5Ad====${list.length}");
    if(list.length<(_h5adBean?.adChance??0)){
      return false;
    }
    h5Ecpm.save("");
    var average = _calculateAverage(list);
    print("kk===checkShowH5Ad====${list.length}=====${average}===");
    return average<(_h5adBean?.adEcpm??0.0);
  }

  double _calculateAverage(List<double> numbers) {
    if (numbers.isEmpty) {
      return 0;
    }
    double sum = numbers.reduce((value, element) => value + element);
    return sum / numbers.length;
  }

  List<double> _getEcpmList(){
    try{
      List<double> list = [];
      for (var value in h5Ecpm.get().split("|")) {
        if(value.isNotEmpty){
          list.add(value.toDou());
        }
      }
      return list;
    }catch(e){
      print("kk==_getEcpmList===${e}");
      return [];
    }
  }
}