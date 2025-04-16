import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/utils/local_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingCon extends GetxController{
  clickItem(text)async{
    switch(text){
      case "Privacy Policy":
        QpRouters.toNamed(routersName: QpRouName.web,arguments: {"url":privacy});
        break;
      case "Term Of User":
        QpRouters.toNamed(routersName: QpRouName.web,arguments: {"url":term});
        break;
      case "Contact Us":
        var uri = Uri(scheme: "mailto",path: email);
        var can = await canLaunchUrl(uri);
        if(can){
          launchUrl(uri);
        }
        break;
    }
  }
}