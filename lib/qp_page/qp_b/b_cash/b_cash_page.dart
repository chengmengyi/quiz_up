import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_page/qp_b/b_cash/b_cash_con.dart';
import 'package:quiz_up/qp_rou/qp_page_list.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';
import 'package:quiz_up/utils/cash_task/task_status.dart';
import 'package:quiz_up/utils/point/app_point_id.dart';
import 'package:quiz_up/utils/point/point_utils.dart';
import 'package:quiz_up/utils/sql/b_sql.dart';
import 'package:quiz_up/utils/utils.dart';

class BCashPage extends StatelessWidget{
  BCashCon bCashCon=Get.put(BCashCon());

  @override
  Widget build(BuildContext context) => Scaffold(
    body: WillPopScope(
      child: Stack(
        children: [
          QpImg(img: "question_bg",width: double.infinity,height: double.infinity,),
          SafeArea(
            top: true,
            bottom: true,
            child: Column(
              children: [
                _topWidget(),
                SizedBox(height: 12.h,),
                _moneyWidget(),
                SizedBox(height: 12.h,),
                _typeListWidget(),
                SizedBox(height: 12.h,),
                _amountWidget(),
              ],
            ),
          ),
        ],
      ),
      onWillPop: ()async{
        return false;
      },
    ),
    resizeToAvoidBottomInset: false,
  );

  _topWidget()=>Row(
    children: [
      SizedBox(width: 16.w,),
      InkWell(
        onTap: (){
          bCashCon.clickClose();
        },
        child: QpImg(img: "icon_close1",width: 30.w,height: 30.h,),
      ),
      SizedBox(width: 10.w,),
      InkWell(
        onTap: (){
          bCashCon.test();
        },
        child: QpText(text: "Withdraw", size: 16.sp, color: "#FFFFFF"),
      )
    ],
  );

  _moneyWidget()=>SizedBox(
    width: double.infinity,
    height: 118.h,
    child: Stack(
      children: [
        GetBuilder<BCashCon>(
          id: "money_bg",
          builder: (_)=>QpImg(img: bCashCon.getMoneyBg(),width: double.infinity,height: double.infinity,),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.only(left: 8.w,top: 2.h),
            padding: EdgeInsets.only(left: 5.w,right: 5.w,top: 3.h,bottom: 3.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.w),
                bottomRight: Radius.circular(16.w),
              ),
              gradient: LinearGradient(colors: ["#FFFDC9".toColor(),"#FFF825".toColor()]),
            ),
            child: QpText(text: "100% Winning", size: 12.sp, color: "#BF5017"),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              QpText(text: "My BALANCE:", size: 13.sp, color: "#000000",fontWeight: FontWeight.bold,),
              GetBuilder<BCashCon>(
                id: "money",
                builder: (_)=>QpText(text: "\$${BSql.instance.bUserInfo?.money??0}", size: 30.sp, color: "#1E8910",fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    ),
  );

  _typeListWidget()=>SizedBox(
    width: double.infinity,
    height: 38.h,
    child: GetBuilder<BCashCon>(
      id: "cash_type",
      builder: (_)=>ListView.builder(
        itemCount: bCashCon.cashTypeList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          var bean = bCashCon.cashTypeList[index];
          return InkWell(
            onTap: (){
              bCashCon.clickCashType(index);
            },
            child: Container(
              height: 38.h,
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(left: 2.w,right: 2.w),
              child: index==bCashCon.cashIndex?
              QpImg(img: bean.largeIcon,height: 38.h,fit: BoxFit.fitHeight,):
              QpImg(img: bean.smallIcon,height: 33.h,fit: BoxFit.fitHeight,),
            ),
          );
        },
      ),
    ),
  );

  _amountWidget()=>Flexible(
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(7.w),
      margin: EdgeInsets.only(left: 12.w,right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.w),
        gradient: LinearGradient(colors: ["#A3EAFD".toColor(),"#79BCE8".toColor()]),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(7.w),
        decoration: BoxDecoration(
          color: "#4574C7".toColor(),
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                QpText(text: "Choose withdraw amount", size: 16.sp, color: "#79D1F9"),
              ],
            ),
            SizedBox(height: 6.h,),
            _amountListWidget(),
            SizedBox(height: 16.h,),
            QpText(text: "Tips：Cash will arrive in your account within 24 hours as soon as possible", size: 12.sp, color: "#7BA5EF",)
          ],
        ),
      ),
    ),
  );

  _amountListWidget()=>Flexible(
    child: GetBuilder<BCashCon>(
      id: "amount",
      builder: (_)=>ListView.builder(
        shrinkWrap: true,
        itemCount: bCashCon.amountList.length,
        itemBuilder: (context,index){
          var bean = bCashCon.amountList[index];
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.w),
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              color: "#C1E5F5".toColor(),
              borderRadius: BorderRadius.circular(12.w),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    QpText(text: "\$${bean.totalMoney}", size: 34.sp, color: "#2AAC23",fontWeight: FontWeight.bold),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        bCashCon.clickCash(index);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          QpImg(img: null==bean.cashTaskBean?"btn4":"btn3",width: 107.w,height: 38.h,),
                          QpText(text: null==bean.cashTaskBean?"Cash out":bean.cashTaskBean?.taskStatus==TaskStatus.completed?"Successful":"Processing", size: 14.sp, color: "#FDFFFC"),
                        ],
                      ),
                    )
                  ],
                ),
                null==bean.cashTaskBean?
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 18.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          LayoutBuilder(
                            builder: (context,bc){
                              var width = bc.maxWidth-4.w;
                              return Container(
                                width: double.infinity,
                                height: 18.h,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 2.w,right: 2.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.w),
                                  color: "#000000".toColor().withOpacity(0.5),
                                ),
                                child:  Container(
                                  width: width*bCashCon.getMoneyPro(bean.totalMoney),
                                  height: 14.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.w),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: ["#F2B839".toColor(),"#DF6224".toColor()],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          QpText(text: bCashCon.getMoneyProStr(bean.totalMoney), size: 14.sp, color: "#FFFFFF")
                        ],
                      ),
                    ),
                    QpImg(img: "icon_money",width: 28.w,height: 28.w,),
                  ],
                ):
                Row(
                  children: [
                    QpImg(img: bCashCon.getTaskIcon(bean.cashTaskBean?.taskType??""),width: 40.w,height: 40.w,),
                    SizedBox(width: 4.w,),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 38.h,
                        padding: EdgeInsets.only(left: 7.w ),
                        decoration: BoxDecoration(
                          color: "#E2F9FF".toColor(),
                          borderRadius: BorderRadius.circular(8.w),
                          border: Border.all(
                            width: 1.w,
                            color: "#67C7E0".toColor(),
                          )
                        ),
                        child: Row(
                          children: [
                            QpText(text: "${bCashCon.getCashTaskProLeftStr(bean.cashTaskBean?.taskType??"")} ", size: 14.sp, color: "#623700"),
                            QpText(text: "${bean.cashTaskBean?.currentPro??0}/${bean.cashTaskBean?.totalPro??0}", size: 14.sp, color: "#FF1A00"),
                            QpText(text: " ${bCashCon.getCashTaskProRightStr(bean.cashTaskBean?.taskType??"")}", size: 14.sp, color: "#623700"),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    ),
  );
}