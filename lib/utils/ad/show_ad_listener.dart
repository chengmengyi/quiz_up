import 'package:applovin_max/applovin_max.dart';
import 'package:quiz_up/bean/ad_bean.dart';

class ShowAdListener{
  Function(MaxAd? ad,AdBean? bean) showSuccess;
  Function(MaxAd? ad) showFail;
  Function() closeAd;
  Function(MaxAd? ad) onAdRevenuePaidCallback;

  ShowAdListener({
    required this.showSuccess,
    required this.showFail,
    required this.closeAd,
    required this.onAdRevenuePaidCallback,
});
}