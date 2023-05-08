class UserModel {
  String name;
  String profilePic;
  String createdAt;
  String phoneNumber;
  int age;
  String gender;
  String uid;

  UserModel({
    required this.name,
    required this.profilePic,
    required this.createdAt,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.uid,
  });

  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      gender: map['gender'] ?? '',
      profilePic: map['profilePic'] ?? '',
      age: map['age'] ?? '',
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
      "gender": gender,
      "age": age
    };
  }
}
