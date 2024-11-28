import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zalo/widgets/common_widget.dart';
import '/Auth/Service/constant.dart';
import '/Auth/Service/database.dart';
import 'dart:math' as math;

import 'conversation_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final DatabaseMethods _data = DatabaseMethods();
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatRoomsStream;

  _getChatRooms() async {
    chatRoomsStream = _data.getChatRooms(Constants.myName);
    setState(() {});
  }

  DateTime currentTime = DateTime.now();

  String _day(DateTime dateTime) {
    return DateFormat('dd:MM:yyyy').format(dateTime);
  }

  @override
  void initState() {
    _getChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: chatRoomsStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoadingIndicator();
          }

          if (snapshot.hasData) {
            var snt = _processChatRooms(snapshot.data!.docs);

            return _buildChatListView(snt, context);
          }
          return buildLoadingIndicator();
        },
      ),
    );
  }

  List<DocumentSnapshot<Map<String, dynamic>>> _processChatRooms(
      List<DocumentSnapshot<Map<String, dynamic>>> chatRooms) {
    chatRooms.removeWhere((element) =>
        element.data()!['time'] == 0 || element.data()!['time'] == null);

    chatRooms.sort((a, b) {
      var aTime = a.data()!['time'];
      var bTime = b.data()!['time'];

      aTime = aTime ?? 0;
      bTime = bTime ?? 0;

      return bTime.compareTo(aTime);
    });

    return chatRooms;
  }

  Widget _buildChatListView(
      List<DocumentSnapshot<Map<String, dynamic>>> chatRooms,
      BuildContext context) {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
      itemBuilder: (context, index) {
        var users = _getUsersList(chatRooms[index]);
        String chatRoom = chatRooms[index].data()!['chatroomId'];
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            chatRooms[index].data()!['time']);
        return _buildChatListItem(
            chatRooms[index], users, chatRoom, dateTime, context);
      },
      separatorBuilder: (context, index) => const Divider(
        height: 0.5,
        thickness: 0.5,
        color: Colors.black12,
      ),
      itemCount: chatRooms.length,
    );
  }

  List<String> _getUsersList(DocumentSnapshot<Map<String, dynamic>> chatRoom) {
    var users = chatRoom
        .data()!['users']
        .toString()
        .replaceAll(']', '')
        .replaceAll('[', '')
        .split(',');

    users.removeWhere((element) => element == Constants.myName);
    return users;
  }

  Widget _buildChatListItem(
      DocumentSnapshot<Map<String, dynamic>> chatRoom,
      List<String> users,
      String chatRoomId,
      DateTime dateTime,
      BuildContext context) {
    return InkWell(
      onTap: () {
        _handleChatRoomTap(chatRoom, chatRoomId, users, context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildUserAvatar(users),
          const SizedBox(width: 10),
          _buildChatDetails(chatRoom, users, dateTime, context),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(List<String> users) {
    return SizedBox.fromSize(
      size: const Size(55, 55),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
              Colors.lightBlue,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: Text(
            users[0].toString().split(' ').last,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatDetails(DocumentSnapshot<Map<String, dynamic>> chatRoom,
      List<String> users, DateTime dateTime, BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserAndTimeRow(chatRoom, users, dateTime),
          const SizedBox(height: 5),
          _buildLastMessageText(chatRoom),
        ],
      ),
    );
  }

  Widget _buildUserAndTimeRow(DocumentSnapshot<Map<String, dynamic>> chatRoom,
      List<String> users, DateTime dateTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          users[0].toString().trimLeft(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            showTime(lastMs: dateTime),
            style: TextStyle(
              color: _checkReadStatus(chatRoom) ? Colors.black54 : Colors.black,
              fontWeight: _checkReadStatus(chatRoom)
                  ? FontWeight.w300
                  : FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastMessageText(
      DocumentSnapshot<Map<String, dynamic>> chatRoom) {
    return Text(
      "${chatRoom.data()?["sendBy"] == Constants.myEmail ? 'Bạn: ' : ''}${chatRoom.data()?["lastMessage"]}",
      style: TextStyle(
        color: _checkReadStatus(chatRoom) ? Colors.black54 : Colors.black,
        fontWeight:
            _checkReadStatus(chatRoom) ? FontWeight.w400 : FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  void _handleChatRoomTap(DocumentSnapshot<Map<String, dynamic>> chatRoom,
      String chatRoomId, List<String> users, BuildContext context) {
    if (chatRoom.data()?['sendBy'] != Constants.myEmail) {
      Map<String, dynamic> updatedRead = {'readed': 1};
      _data.updateLastMessageSend(chatRoomId, updatedRead);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ConversationScreen(chatRoomId: chatRoomId, User: users[0]),
      ),
    );
  }

  bool _checkReadStatus(DocumentSnapshot<Map<String, dynamic>> chatRoom) {
    return checkRead(
      sendBy: chatRoom.data()?["sendBy"],
      read: chatRoom.data()?["readed"],
    );
  }

  bool checkRead({required String sendBy, required int read}) {
    if (sendBy == Constants.myEmail) {
      return true;
    } else {
      if (read == 0) {
        return false;
      } else {
        return true;
      }
    }
  }

  String showTime({required DateTime lastMs}) {
    if (_day(currentTime) == _day(lastMs)) {
      return DateFormat('hh:mm').format(lastMs);
    } else {
      return DateFormat('hh:mm, d TM').format(lastMs);
    }
  }
}
