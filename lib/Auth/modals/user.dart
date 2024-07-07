// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  Users({
    required this.birthDay,
    required this.gender,
    required this.name,
    required this.email,
  });

  final String birthDay;
  final String gender;
  final String name;
  final String email;

  factory Users.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return Users(
      birthDay: doc.data()!["birthDay"],
      gender: doc.data()!["gender"],
      name: doc.data()!["name"],
      email: doc.data()!["email"],
    );
  }
}
