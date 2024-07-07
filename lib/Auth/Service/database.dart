import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_myapp/Auth/modals/user.dart';

List<Users> listUsers = [];
final Reference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection("users");
final postsRef = FirebaseFirestore.instance.collection("posts");

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("name", isEqualTo: username)
        .get();
  }

  Future<QuerySnapshot> getUserByUserEmail(String userEmail) async {
    var user = userEmail.trimRight();
    print(user);
    dynamic val = await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: user)
        .get();
    return val;
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("Users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .get();
    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(chatRoomId)
          .set(chatRoomMap)
          .catchError((e) {
        print(e.toString());
      });
    }
  }

  Future addConversationMessage(String chatRoomId, messageMap) async {
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  updateLastMessageSend(String chatRoomId, lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getConversationMessage(
      String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getChatRoom(
      String email) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: email)
        .snapshots();
  }

  getAllUser() {
    return FirebaseFirestore.instance
        .collection("Users")
        .snapshots()
        .map((users) {
      final List<Users> list = [];
      for (final DocumentSnapshot<Map<String, dynamic>> doc in users.docs) {
        list.add(Users.fromDocumentSnapshot(doc: doc));
      }
      return list;
    });
  }

  Users getUser(String email) {
    var list = listUsers
        .where(
            (element) => element.email.replaceAll('@gmail.coom', "") == email)
        .toList();
    return list[0];
  }
}
