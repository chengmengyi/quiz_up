class NewCashTaskBean {
  NewCashTaskBean({
      this.cashType, 
      this.cashNum, 
      this.taskStep,
      this.currentPro, 
      this.totalPro, 
      this.account,
      this.taskIndex,
  });

  NewCashTaskBean.fromJson(dynamic json) {
    cashType = json['cashType'];
    cashNum = json['cashNum'];
    taskStep = json['taskStep'];
    currentPro = json['currentPro'];
    totalPro = json['totalPro'];
    account = json['account'];
    taskIndex = json['taskIndex'];
  }
  int? cashType;
  int? cashNum;
  String? taskStep;
  int? currentPro;
  int? totalPro;
  String? account;
  int? taskIndex;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cashType'] = cashType;
    map['cashNum'] = cashNum;
    map['taskStep'] = taskStep;
    map['currentPro'] = currentPro;
    map['totalPro'] = totalPro;
    map['account'] = account;
    map['taskIndex'] = taskIndex;
    return map;
  }

}