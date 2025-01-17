import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz_up/qp_dialog/dialog_b/comment/comment/comment_con.dart';
import 'package:quiz_up/qp_wid/qp_img.dart';
import 'package:quiz_up/qp_wid/qp_text.dart';

class CommentDialog extends StatelessWidget{
  bool init=false;
  late CommentCon commentCon;

  Function(int stars) dismiss;
  CommentDialog({required this.dismiss});

  @override
  Widget build(BuildContext context){
    if(!init){
      commentCon=Get.put(CommentCon());
      init=true;
    }
    return WillPopScope(
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: _contentWidget(),
        ),
      ),
      onWillPop: ()async{
        return false;
      },
    );
  }
  _contentWidget()=>SizedBox(
    width: double.infinity,
    height: 404.h,
    child: Stack(
      children: [
        QpImg(img: "c1",width: double.infinity,height: double.infinity,),
        Positioned(
          top: 33.h,
          right: 25.w,
          child: InkWell(
            onTap: (){
              commentCon.clickClose(dismiss);
            },
            child: QpImg(img: "icon_close3",width: 38.w,height: 38.h,),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QpText(text: "Give Us A Good Review", size: 22.sp, color: "#FD8700"),
              SizedBox(height: 6.h,),
              QpImg(img: "c2",width: 120.w,height: 94.h,),
              Container(
                width: double.infinity,
                height: 48.h,
                alignment: Alignment.center,
                child: GetBuilder<CommentCon>(
                  id: "list",
                  builder: (_)=>ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index)=>InkWell(
                      onTap: (){
                        commentCon.clickStar(index,dismiss);
                      },
                      child: QpImg(img: commentCon.chooseIndex>=index?"c4":"c3",width: 48.w,height: 48.h,),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QpText(text: "Complete reviews earn 5", size: 14.sp, color: "#085F75"),
                  QpImg(img: "icon_money",width: 26.w,height: 26.h,),
                ],
              ),
              SizedBox(height: 6.h,),
              InkWell(
                onTap: (){
                  commentCon.clickStar(4,dismiss);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QpImg(img: "btn2",width: 228.w,height: 60.h,),
                    QpText(text: "Give 5 Stars", size: 20.sp, color: "#FFFFFF")
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ),
  );

}