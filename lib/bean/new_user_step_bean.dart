class NewUserStepBean {
  NewUserStepBean({
      this.newUserStep, 
      this.completedTimer,});

  NewUserStepBean.fromJson(dynamic json) {
    id = json['id'];
    newUserStep = json['newUserStep'];
    completedTimer = json['completedTimer'];
  }
  int? id;
  String? newUserStep;
  String? completedTimer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['newUserStep'] = newUserStep;
    map['completedTimer'] = completedTimer;
    return map;
  }

  @override
  String toString() {
    return 'NewUserStepBean{id: $id, newUserStep: $newUserStep, completedTimer: $completedTimer}';
  }
}