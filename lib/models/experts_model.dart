class ExpertModel {
  String name;
  String profilePic;
  String createdAt;
  double pricePerDay;
  String phoneNumber;
  String speciality;
  String experience;

  String uid;
  String deviceToken;
  bool isApproved = false;
  bool isFav = false;

  ExpertModel({
    required this.name,
    required this.profilePic,
    required this.createdAt,
    required this.pricePerDay,
    required this.phoneNumber,
    required this.speciality,
    required this.experience,
    required this.uid,
    required this.deviceToken,
    required this.isApproved,
  });

  // from map
  factory ExpertModel.fromMap(Map<String, dynamic> map) {
    return ExpertModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      profilePic: map['profilePic'] ?? '',
      speciality: map['speciality'] ?? '',
      experience: map['experience'] ?? '',
      deviceToken: map['deviceToken'] ?? '',
      isApproved: map['isApproved'] ?? '',
      pricePerDay: map['pricePerDay'],
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "uid": uid,
      "profilePic": profilePic,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
      "speciality": speciality,
      "experience": experience,
      "pricePerDay": pricePerDay,
      "isApproved": isApproved,
      "deviceToken": deviceToken,
      "isFav": isFav
    };
  }
}
