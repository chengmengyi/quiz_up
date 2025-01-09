
class AdUtils {
  static final AdUtils _utils=AdUtils();
  static AdUtils get instance=>_utils;

  showAd({
    required Function() closeAd,

  }){
    closeAd.call();
  }
}