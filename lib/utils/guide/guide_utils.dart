import 'package:quiz_up/bean/new_user_step_bean.dart';
import 'package:quiz_up/bean/old_user_step_bean.dart';
import 'package:quiz_up/qp_dialog/dialog_b/old_user/old_user_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/old_user_double/old_user_double_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/old_user_sign/old_user_sign_dialog.dart';
import 'package:quiz_up/qp_dialog/dialog_b/wheel/wheel_dialog.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/utils.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

class GuideUtils{
  static final GuideUtils _guideUtils=GuideUtils();
  static GuideUtils get instance=>_guideUtils;

  NewUserStepBean? _newUserStepBean;
  OldUserStepBean? _oldUserStepBean;

  queryNewUserBean()async{
    _newUserStepBean = await BSql.instance.queryNewGuideInfo();
  }

  checkUserGuide()async{
    print("kk===_newUserStepBean=====${_newUserStepBean?.toString()}");
    switch(_newUserStepBean?.newUserStep){
      case NewUserStep.showRightAnswerFinger:
        SendEvent(code: EventCode.newUserStepOne).send();
        break;
      case NewUserStep.showNewUserDialog:
        SendEvent(code: EventCode.newUserStepTwo).send();
        break;
      case NewUserStep.toCashPage:
        toNamed(routersName: QpRouName.bCash,arguments: {"fromNewUser":true});
        break;
      case NewUserStep.newUserGuideCompleted:
        SendEvent(code: EventCode.showBubble).send();
        _checkOldUserStep();
        break;
    }
  }

  _checkOldUserStep({int wheelAddNum=0})async{
    _oldUserStepBean ??= await BSql.instance.queryOldGuideInfo();
    print("kk===_oldUserStepBean=====${_oldUserStepBean?.toString()}");
    // if(_oldUserStepBean?.stepTimer==_newUserStepBean?.completedTimer){
    //   return;
    // }
    switch(_oldUserStepBean?.oldUserStep){
      case OldUserStep.showOldUserDialog:
        showDialog(
          widget: OldUserDialog()
        );
        break;
      case OldUserStep.showWheelDialog:
        showDialog(
          useSafeArea: false,
          widget: WheelDialog(autoWheel: true,fromOldUser: true,),
        );
        break;
      case OldUserStep.showDoubleDialog:
        showDialog(
          useSafeArea: false,
          widget: OldUserDoubleDialog(
            wheelAddNum: wheelAddNum==0?ValueUtils.instance.getWheelAddNum():wheelAddNum,
          ),
        );
        break;
      case OldUserStep.showSignDialog:
        showDialog(
          useSafeArea: false,
          widget: OldUserSignDialog(),
        );
        break;
    }
  }


  updateNewUserStep(String step)async{
    _newUserStepBean?.newUserStep=step;
    if(step==NewUserStep.newUserGuideCompleted){
      _newUserStepBean?.completedTimer=getTodayTime();
    }
    await BSql.instance.updateNewUserStep(_newUserStepBean);
    checkUserGuide();
  }

  updateOldUserStep(String step,{int wheelAddNum=0})async{
    _oldUserStepBean?.oldUserStep=step;
    _oldUserStepBean?.stepTimer=getTodayTime();
    await BSql.instance.updateOldUserStep(_oldUserStepBean);
    _checkOldUserStep(wheelAddNum: wheelAddNum);
  }

  bool isNewUserFirstStep() => _newUserStepBean?.newUserStep==NewUserStep.showRightAnswerFinger;
}