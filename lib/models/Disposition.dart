class Disposition {
  int dispositionID;
  String dispositionTitle;

  Disposition(this.dispositionID, this.dispositionTitle);

  factory Disposition.fromJson(dynamic json) {
    return Disposition(json['dispositionID'] as int, json['dispositionTitle'] as String);
  }

  @override
  String toString() {
    return '{ ${this.dispositionID}, ${this.dispositionTitle} }';
  }
}