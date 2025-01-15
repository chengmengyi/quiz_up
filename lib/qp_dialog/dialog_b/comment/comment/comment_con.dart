import 'package:get/get.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';

class CommentCon extends GetxController{
  var canClick=true,chooseIndex=-1;

  clickClose(Function(int stars) dismiss){
    if(!canClick){
      return;
    }
    back();
  }

  clickStar(index,Function(int stars) dismiss)async{
    if(!canClick){
      return;
    }
    canClick=false;
    chooseIndex=index;
    update(["list"]);
    await Future.delayed(Duration(milliseconds: 800));
    back();
    dismiss.call(index);
  }
}