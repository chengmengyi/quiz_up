class QuestionBean {
  QuestionBean({
      this.qpQues, 
      this.qpFirst, 
      this.qpSecond, 
      this.qpResult,});

  QuestionBean.fromJson(dynamic json) {
    qpQues = json['qp_ques'];
    qpFirst = json['qp_first'];
    qpSecond = json['qp_second'];
    qpResult = json['qp_result'];
  }
  String? qpQues;
  String? qpFirst;
  String? qpSecond;
  String? qpResult;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['qp_ques'] = qpQues;
    map['qp_first'] = qpFirst;
    map['qp_second'] = qpSecond;
    map['qp_result'] = qpResult;
    return map;
  }

}