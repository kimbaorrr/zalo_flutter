import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.message,
    required this.sendBy,
    required this.time,
  });

  final String message;
  final String sendBy;
  final DateTime time;

  factory Message.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return Message(
      message: doc.data()!["message"],
      sendBy: doc.data()!["sendBy"],
      time: doc.data()!["time"],
    );
  }
}
