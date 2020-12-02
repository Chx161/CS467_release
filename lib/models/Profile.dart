import 'dart:typed_data';

class Profile {
  final String availability, petName, status, type, description, createdDate;
  Uint8List image;
  String breed;
  final int profileID,
      shelterID,
      breedID,
      goodWithAnimal,
      goodWithChild,
      leashed,
      isDeleted;

  Profile({
    this.profileID,
    this.shelterID,
    this.breedID,
    this.goodWithAnimal,
    this.goodWithChild,
    this.leashed,
    this.isDeleted,
    this.type,
    this.description,
    this.createdDate,
    this.availability,
    this.petName,
    this.status,
    this.image,
    this.breed
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileID: json['profileID'],
      shelterID: json['shelterID'],
      breedID: json['breedID'],
      goodWithAnimal: json['goodWithAnimal'],
      goodWithChild: json['goodWithChild'],
      leashed: json['leashed'],
      isDeleted: json['isDeleted'],
      type: json['type'],
      description: json['description'],
      createdDate: json['createdDate'],
      availability: json['availability'] == null ? "No availability information" : json['availability'],
      petName: json['petName'],
      status: json['status'],
      // image: ""
    );
  }

  set setImage(Uint8List newImage) {
    this.image = newImage;
  }

  set setBreed(String newBreed) {
    this.breed = newBreed;
  }
}

// Profile.fromMap(String uid, Map<String, dynamic> data)
//       : this(
//     profileID: uid,
//     type: data['type'],
//     breed: data['breed'],
//     availability: data['availability'],
//     name: data['name'],
//     status: data['status'],
//     image: "assets/images/golden_retriever.jpg",
//     gWAnimal: data['gWAnimal'],
//     gWChild: data['gWChild'],
//     mleashed: data['mleashed'],
//   );
//
// Map<String, dynamic> toJson() => {
//   'type': this.type,
//   'breed': this.breed,
//   'name': this.name,
//   'availability': this.availability,
//   'status': this.status,
//   'image': this.image,
//   'gWAnimal': this.gWAnimal,
//   'gWChild': this.gWChild,
//   "mleashed": this.mleashed,
// };
