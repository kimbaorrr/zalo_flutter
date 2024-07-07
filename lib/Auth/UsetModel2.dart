class UserModel {
  String? uid;
  String? name;
  String? gender;
  DateTime? date;
  String? confirmPw;

  UserModel({this.uid, this.name, this.gender, this.date, this.confirmPw});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        name: map['name'],
        gender: map['gender'],
        date: map['date'],
        confirmPw: map['confirmPw']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'gender': gender,
      'date': date,
      'confirmPw': confirmPw
    };
  }
}
