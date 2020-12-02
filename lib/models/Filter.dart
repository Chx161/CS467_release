class Filter {
  // Map data = {
  //   'type': selectedType,
  //   // 'shelterID': preferences.getInt("userID").toString(),
  //   'breedID': selectedBreed.toString(),
  //   'availability': selectedAvail,
  //   'goodWithAnimal': goodWithAnimal?"1":"0",
  //   'goodWithChild': goodWithChild?"1":"0",
  //   'leashed': leashed?"1":"0"
  // };

  String type, availability;
  int breedID, goodWithAnimal, goodWithChild, leashed;

  Filter(this.breedID, this.goodWithAnimal, this.goodWithChild, this.leashed,
      this.type, this.availability);

  Map<String, dynamic> toJson() => {
    'type': this.type,
    'breedID': this.breedID,
    'availability': this.availability,
    'goodWithAnimal': this.goodWithAnimal,
    'goodWithChild': this.goodWithChild,
    'leashed': this.leashed,
};
}
