import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_up/qp_rou/qp_rou_name.dart';
import 'package:quiz_up/utils/check_user/check_user_utils.dart';
import 'package:quiz_up/utils/firebase_utils.dart';
import 'package:quiz_up/utils/guide/guide_utils.dart';
import 'package:quiz_up/utils/h5_utils.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/progress/progress_utils.dart';
import 'package:quiz_up/utils/question/a_question_utils.dart';
import 'package:quiz_up/utils/question/b_question_util.dart';
import 'package:quiz_up/utils/sql/a_sql.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/value/value_utils.dart';

import 'qp_rou/qp_page_list.dart';

void main() {
  _init();
  runApp(const MyApp());
}

_init()async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarDividerColor: null,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      )
  );
  await GetStorage.init();
  PointUtils.instance.install();
  //a
  AQuestionUtils.instance.initQuestionList();
  ASql.instance.initQuestionAndUserInfoData();

  //b
  FirebaseUtils.instance.checkWorkNet();
  BQuestionUtil.instance.initQuiz();
  BSql.instance.queryUserInfo();
  ValueUtils.instance.initValue();
  GuideUtils.instance.queryNewUserBean();
  ProgressUtils.instance.getProgressList();


  CheckUserUtils.instance.initCheck();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    H5Utils.instance.initChannel(context);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (c,child)=>GetMaterialApp(
        title: 'QuizUp',
        enableLog: true,
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        initialRoute: QpRouName.launch,
        debugShowCheckedModeBanner: false,
        getPages: pageList,
        defaultTransition: Transition.rightToLeft,
        builder: (context,widget){
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
      ),
    );
  }
}