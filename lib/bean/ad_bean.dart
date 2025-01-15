class AdBean {
  AdBean({
      this.balemcur, 
      this.irispgjr, 
      this.mtuskwlf, 
      this.neigksge, 
      this.pfmrybke,});

  AdBean.fromJson(dynamic json) {
    balemcur = json['balemcur'];
    irispgjr = json['irispgjr'];
    mtuskwlf = json['mtuskwlf'];
    neigksge = json['neigksge'];
    pfmrybke = json['pfmrybke'];
  }
  String? balemcur;
  String? irispgjr;
  String? mtuskwlf;
  int? neigksge;
  int? pfmrybke;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['balemcur'] = balemcur;
    map['irispgjr'] = irispgjr;
    map['mtuskwlf'] = mtuskwlf;
    map['neigksge'] = neigksge;
    map['pfmrybke'] = pfmrybke;
    return map;
  }

  @override
  String toString() {
    return 'AdBean{balemcur: $balemcur, irispgjr: $irispgjr, mtuskwlf: $mtuskwlf, neigksge: $neigksge, pfmrybke: $pfmrybke}';
  }
}