enum ProgressType{
  empty,box,wheel,
}

class ProgressBean{
  ProgressType progressType;
  bool received;
  ProgressBean({
    required this.progressType,
    required this.received,
});
}