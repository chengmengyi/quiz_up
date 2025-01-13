class CashTaskBean {
  CashTaskBean({
      this.cashType, 
      this.cashNum, 
      this.taskType, 
      this.currentPro, 
      this.totalPro, 
      this.account,
      this.taskIndex,
      this.taskStatus,
  });

  CashTaskBean.fromJson(dynamic json) {
    cashType = json['cashType'];
    cashNum = json['cashNum'];
    taskType = json['taskType'];
    currentPro = json['currentPro'];
    totalPro = json['totalPro'];
    account = json['account'];
    taskIndex = json['taskIndex'];
    taskStatus = json['taskStatus'];
  }
  int? cashType;
  int? cashNum;
  String? taskType;
  int? currentPro;
  int? totalPro;
  String? account;
  int? taskIndex;
  int? taskStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cashType'] = cashType;
    map['cashNum'] = cashNum;
    map['taskType'] = taskType;
    map['currentPro'] = currentPro;
    map['totalPro'] = totalPro;
    map['account'] = account;
    map['taskIndex'] = taskIndex;
    map['taskStatus'] = taskStatus;
    return map;
  }

}