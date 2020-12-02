class Breed {
  int breedID;
  String breedName;
  String type;

  Breed(this.breedID, this.breedName, this.type);

  factory Breed.fromJson(dynamic json) {
    return Breed(json['breedID'] as int, json['breedName'] as String, json['type'] as String);
  }

  @override
  String toString() {
    return '{ ${this.breedID}, ${this.breedName}, ${this.type} }';
  }
}