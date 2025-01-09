class OldUserStepBean {
  OldUserStepBean({
      this.oldUserStep, 
      this.stepTimer,});

  OldUserStepBean.fromJson(dynamic json) {
    id = json['id'];
    oldUserStep = json['oldUserStep'];
    stepTimer = json['stepTimer'];
  }
  int? id;
  String? oldUserStep;
  String? stepTimer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['oldUserStep'] = oldUserStep;
    map['stepTimer'] = stepTimer;
    return map;
  }

  @override
  String toString() {
    return 'OldUserStepBean{id: $id, oldUserStep: $oldUserStep, stepTimer: $stepTimer}';
  }
}