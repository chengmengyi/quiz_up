import 'package:decimal/decimal.dart';
import 'package:quiz_up/bean/b_user_info.dart';
import 'package:quiz_up/bean/new_user_step_bean.dart';
import 'package:quiz_up/bean/old_user_step_bean.dart';
import 'package:quiz_up/utils/event/event_code.dart';
import 'package:quiz_up/utils/event/send_event.dart';
import 'package:quiz_up/utils/guide/guide_step.dart';
import 'package:quiz_up/utils/sql/base_sql.dart';
import 'package:quiz_up/utils/utils.dart';

class BSql extends BaseSql{
  static final BSql _sql=BSql();
  static BSql get instance  => _sql;

  BUserInfo? bUserInfo;

  queryUserInfo()async{
    var db = await initDB();
    var list = await db.query(TableName.userInfoB);
    if(list.isEmpty){
      bUserInfo=BUserInfo(money: 0.0, answerRightNum: 0, answerNum: 0, answerIndex: 0);
      var id = await db.insert(TableName.userInfoB, bUserInfo?.toJson()??{});
      bUserInfo?.id=id;
      return;
    }
    bUserInfo = BUserInfo.fromJson(list.first);
  }

  updateUserMoney(double addNum)async{
    var d = Decimal.parse("$addNum")+Decimal.parse("${bUserInfo?.money??0.0}");
    bUserInfo?.money=d.toDouble();
    await updateUserInfo();
    SendEvent(code: EventCode.updateUserMoney).send();
  }

  updateUserInfo()async{
    var db = await initDB();
    var list = await db.query(TableName.userInfoB);
    if(list.isEmpty){
      return;
    }
    await db.update(TableName.userInfoB, bUserInfo?.toJson()??{},where: '"id" = ?', whereArgs: [bUserInfo?.id]);
  }

  Future<NewUserStepBean> queryNewGuideInfo()async{
    var db = await initDB();
    var list = await db.query(TableName.newUserGuideB);
    if(list.isEmpty){
      var stepBean = NewUserStepBean(newUserStep: NewUserStep.showRightAnswerFinger);
      var id = await db.insert(TableName.newUserGuideB, stepBean.toJson());
      stepBean.id=id;
      return stepBean;
    }
    return NewUserStepBean.fromJson(list.first);
  }

  updateNewUserStep(NewUserStepBean? bean)async{
    var db = await initDB();
    db.update(TableName.newUserGuideB, bean?.toJson()??{},where: '"id" = ?', whereArgs: [bean?.id]);
  }

  Future<OldUserStepBean> queryOldGuideInfo()async{
    var db = await initDB();
    var list = await db.query(TableName.oldUserGuideB,where: '"stepTimer" = ?', whereArgs: [getTodayTime()]);
    if(list.isEmpty){
      var stepBean = OldUserStepBean(oldUserStep: OldUserStep.showOldUserDialog,stepTimer: getTodayTime());
      var id = await db.insert(TableName.oldUserGuideB, stepBean.toJson());
      stepBean.id=id;
      return stepBean;
    }
    return OldUserStepBean.fromJson(list.first);
  }

  updateOldUserStep(OldUserStepBean? bean)async{
    var db = await initDB();
    db.update(TableName.oldUserGuideB, bean?.toJson()??{},where: '"id" = ?', whereArgs: [bean?.id]);
  }
}