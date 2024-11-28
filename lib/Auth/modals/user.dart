import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  Users(
      {required this.birthDay,
      required this.gender,
      required this.name,
      required this.email,
      required this.avatar,
      required this.friends});

  final String birthDay;
  final String gender;
  final String name;
  final String email;
  final String avatar;
  final List<dynamic> friends;

  factory Users.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return Users(
        birthDay: doc.data()!["birthDay"],
        gender: doc.data()!["gender"],
        name: doc.data()!["name"],
        email: doc.data()!["email"],
        avatar: doc.data()!["avatar"],
        friends: List<String>.from(doc.data()!["friends"] ?? []));
  }
}
