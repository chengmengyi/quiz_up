import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QpWWWWWCon extends GetxController{
  late WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    var url = QpRouters.getArguments()["url"];
    webViewController=WebViewController()..loadRequest(Uri.parse(url));
  }
}