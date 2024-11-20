import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zalo/Auth/UserModel.dart';
import '/Auth/modals/user.dart';

List<Users> listUsers = [];

final Reference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection("Users");
final postsRef = FirebaseFirestore.instance.collection("posts");
final chatRoomRef = FirebaseFirestore.instance.collection("ChatRoom");

class DatabaseMethods {
  Future<QuerySnapshot> getUserByUserName(String userName) async {
    return await usersRef.where("name", isEqualTo: userName).get();
  }

  Future<QuerySnapshot> getUserByUserEmail(String userEmail) async {
    var user = userEmail.toLowerCase().trim();
    return await usersRef.where("email", isEqualTo: user).get();
  }

  Future<bool> addOrRemoveFriend(
      bool type, String userName, String friendName) async {
    try {
      QuerySnapshot userSnapshot = await getUserByUserName(userName);

      if (userSnapshot.docs.isEmpty) {
        print("User with email $userName not found");
        return false;
      }
      String userId = userSnapshot.docs.first.id;
      DocumentReference userDocRef = usersRef.doc(userId);
      if (type) {
        await userDocRef.update({
          'friends': FieldValue.arrayUnion([friendName]),
        });
        print("Added $friendName to $userName's friends");
      } else {
        await userDocRef.update({
          'friends': FieldValue.arrayRemove([friendName]),
        });
        print("Removed $friendName from $userName's friends");
      }
      return true;
    } catch (e) {
      print('Failed to add or remove friend: $e');
      return false;
    }
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("Users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  Future<bool> createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomMap) async {
    final snapShot = await chatRoomRef.doc(chatRoomId).get();
    if (snapShot.exists) {
      return true;
    } else {
      await chatRoomRef.doc(chatRoomId).set(chatRoomMap).catchError((e) {
        print("Error creating chat room: $e");
      });
      return false;
    }
  }

  Future<void> addConversationMessage(
      String chatRoomId, Map<String, dynamic> messageMap) async {
    await chatRoomRef
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print("Error adding message: $e");
    });
  }

  Future<void> updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) async {
    await chatRoomRef
        .doc(chatRoomId)
        .update(lastMessageInfoMap)
        .catchError((e) {
      print("Error updating last message: $e");
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getConversationMessages(
      String chatRoomId) {
    return chatRoomRef
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRooms(String email) {
    return chatRoomRef.where("users", arrayContains: email).snapshots();
  }

  Stream<List<Users>> getAllUsers() {
    return usersRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Users.fromDocumentSnapshot(doc: doc);
      }).toList();
    });
  }

  Users getUser(String email) {
    var list = listUsers
        .where((element) => element.email.replaceAll('@gmail.com', "") == email)
        .toList();

    return list.isNotEmpty
        ? list[0]
        : Users(
            birthDay: "",
            gender: "",
            name: "",
            email: "",
            avatar: "",
            friends: List.empty());
  }
}
