class BUserInfo {
  BUserInfo({
    required this.money,
    required this.answerRightNum,
    required this.answerNum,
    required this.answerIndex,
});


  BUserInfo.fromJson(dynamic json) {
    id = json['id'];
    money = json['money'];
    answerRightNum = json['answerRightNum'];
    answerNum = json['answerNum'];
    answerIndex = json['answerIndex'];
  }
  int id=-1;
  double money=0.0;
  int answerRightNum=0;
  int answerNum=0;
  int answerIndex=0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['money'] = money;
    map['answerRightNum'] = answerRightNum;
    map['answerNum'] = answerNum;
    map['answerIndex'] = answerIndex;
    return map;
  }

}