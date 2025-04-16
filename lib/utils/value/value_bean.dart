class ValueBean {
  ValueBean({
    this.eqRange,
    this.newPrize,
    this.intadPoint,
    this.intPopAd,
    this.rvadPoint,
    this.quizPrize,
    this.floatPrize,
    this.boxPrize,
    this.wheel,
    this.tixianTask,
    this.checkPrize,
    this.queueAll,
    this.queueCurrent,
  });

  ValueBean.fromJson(dynamic json) {
    eqRange = json['eq_range'] != null ? json['eq_range'].cast<int>() : [];
    newPrize = json['new_prize'];
    queueAll = json['queue_all'] != null ? QueueAll.fromJson(json['queue_all']) : null;
    queueCurrent = json['queue_current'] != null ? QueueCurrent.fromJson(json['queue_current']) : null;
    if (json['intad_point'] != null) {
      intadPoint = [];
      json['intad_point'].forEach((v) {
        intadPoint?.add(IntadPoint.fromJson(v));
      });
    }
    if (json['int_pop_ad'] != null) {
      intPopAd = [];
      json['int_pop_ad'].forEach((v) {
        intPopAd?.add(IntadPoint.fromJson(v));
      });
    }
    if (json['rvad_point'] != null) {
      rvadPoint = [];
      json['rvad_point'].forEach((v) {
        rvadPoint?.add(IntadPoint.fromJson(v));
      });
    }
    if (json['quiz_prize'] != null) {
      quizPrize = [];
      json['quiz_prize'].forEach((v) {
        quizPrize?.add(QuizPrize.fromJson(v));
      });
    }
    if (json['float_prize'] != null) {
      floatPrize = [];
      json['float_prize'].forEach((v) {
        floatPrize?.add(QuizPrize.fromJson(v));
      });
    }
    if (json['box_prize'] != null) {
      boxPrize = [];
      json['box_prize'].forEach((v) {
        boxPrize?.add(QuizPrize.fromJson(v));
      });
    }
    wheel = json['wheel'] != null ? Wheel.fromJson(json['wheel']) : null;
    if (json['tixian_task'] != null) {
      tixianTask = [];
      json['tixian_task'].forEach((v) {
        tixianTask?.add(TixianTask.fromJson(v));
      });
    }
    if (json['check_prize'] != null) {
      checkPrize = [];
      json['check_prize'].forEach((v) {
        checkPrize?.add(QuizPrize.fromJson(v));
      });
    }
  }
  List<int>? eqRange;
  int? newPrize;
  List<IntadPoint>? intadPoint;
  List<IntadPoint>? intPopAd;
  List<IntadPoint>? rvadPoint;
  List<QuizPrize>? quizPrize;
  List<QuizPrize>? floatPrize;
  List<QuizPrize>? boxPrize;
  Wheel? wheel;
  List<TixianTask>? tixianTask;
  List<QuizPrize>? checkPrize;
  QueueAll? queueAll;
  QueueCurrent? queueCurrent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['eq_range'] = eqRange;
    map['new_prize'] = newPrize;
    if (queueAll != null) {
      map['queue_all'] = queueAll?.toJson();
    }
    if (queueCurrent != null) {
      map['queue_current'] = queueCurrent?.toJson();
    }
    if (intadPoint != null) {
      map['intad_point'] = intadPoint?.map((v) => v.toJson()).toList();
    }

    if (intPopAd != null) {
      map['int_pop_ad'] = intPopAd?.map((v) => v.toJson()).toList();
    }

    if (rvadPoint != null) {
      map['rvad_point'] = rvadPoint?.map((v) => v.toJson()).toList();
    }
    if (quizPrize != null) {
      map['quiz_prize'] = quizPrize?.map((v) => v.toJson()).toList();
    }
    if (floatPrize != null) {
      map['float_prize'] = floatPrize?.map((v) => v.toJson()).toList();
    }
    if (boxPrize != null) {
      map['box_prize'] = boxPrize?.map((v) => v.toJson()).toList();
    }
    if (wheel != null) {
      map['wheel'] = wheel?.toJson();
    }
    if (tixianTask != null) {
      map['tixian_task'] = tixianTask?.map((v) => v.toJson()).toList();
    }
    if (checkPrize != null) {
      map['check_prize'] = checkPrize?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class QueueCurrent {
  QueueCurrent({
    this.intCurrent,
    this.intCurrentDelete,});

  QueueCurrent.fromJson(dynamic json) {
    intCurrent = json['int_current'];
    intCurrentDelete = json['int_current_delete'] != null ? json['int_current_delete'].cast<int>() : [];
  }
  int? intCurrent;
  List<int>? intCurrentDelete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['int_current'] = intCurrent;
    map['int_current_delete'] = intCurrentDelete;
    return map;
  }

}

class QueueAll {
  QueueAll({
    this.intAll,
    this.intAllDelete,});

  QueueAll.fromJson(dynamic json) {
    intAll = json['int_all'];
    intAllDelete = json['int_all_delete'] != null ? json['int_all_delete'].cast<int>() : [];
  }
  int? intAll;
  List<int>? intAllDelete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['int_all'] = intAll;
    map['int_all_delete'] = intAllDelete;
    return map;
  }

}

class TixianTask {
  TixianTask({
      this.title, 
      this.data,});

  TixianTask.fromJson(dynamic json) {
    title = json['title'];
    data = json['data'];
  }
  String? title;
  int? data;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['data'] = data;
    return map;
  }

}

class Wheel {
  Wheel({
      this.point5, 
      this.point10, 
      this.point20, 
      this.point50, 
      this.point80, 
      this.iphonePoint,});

  Wheel.fromJson(dynamic json) {
    point5 = json['point_5'];
    point10 = json['point_10'];
    point20 = json['point_20'];
    point50 = json['point_50'];
    point80 = json['point_80'];
    iphonePoint = json['iphone_point'];
  }
  int? point5;
  int? point10;
  int? point20;
  int? point50;
  int? point80;
  int? iphonePoint;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['point_5'] = point5;
    map['point_10'] = point10;
    map['point_20'] = point20;
    map['point_50'] = point50;
    map['point_80'] = point80;
    map['iphone_point'] = iphonePoint;
    return map;
  }
}

class QuizPrize {
  QuizPrize({
    this.firstNumber,
    this.prize,
    this.endNumber,});

  QuizPrize.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    prize = json['prize'] != null ? json['prize'].cast<int>() : [];
    endNumber = json['end_number'];
  }

  int? firstNumber;
  List<int>? prize;
  int? endNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_number'] = firstNumber;
    map['prize'] = prize;
    map['end_number'] = endNumber;
    return map;
  }

}

class IntadPoint {
  IntadPoint({
      this.firstNumber, 
      this.point, 
      this.endNumber,});

  IntadPoint.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    point = json['point'];
    endNumber = json['end_number'];
  }
  int? firstNumber;
  int? point;
  int? endNumber;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_number'] = firstNumber;
    map['point'] = point;
    map['end_number'] = endNumber;
    return map;
  }

}