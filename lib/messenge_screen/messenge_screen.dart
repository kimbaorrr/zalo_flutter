import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_myapp/Auth/Service/constant.dart';
import 'package:flutter_myapp/Auth/Service/database.dart';
import 'dart:math' as math;

import 'conversation_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final DatabaseMethods _data = DatabaseMethods();
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatRoomsStream;
  // thông tin user
  getChatRooms() async {
    chatRoomsStream = await _data.getChatRoom(Constants.myName);
    setState(() {});
  }

  DateTime currentTime = DateTime.now();

  String day(DateTime dateTime) {
    return DateFormat('dd:MM:yyyy').format(dateTime);
  }

  @override
  void initState() {
    getChatRooms();
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              var snt = snapshot.data!.docs;
              snt.removeWhere((element) => element.data()['time'] == 0);
              snt.sort((a, b) => b.data()['time'].compareTo(a.data()['time']));
              return ListView.separated(
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
                itemBuilder: (context, index) {
                  var list = snt[index]
                      .data()['users']
                      .toString()
                      .replaceAll(']', '')
                      .replaceAll('[', '')
                      .split(',');
                  String chatRoom = snt[index].data()['chatroomId'];
                  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                      snt[index].data()['time']);
                  list.removeWhere((element) => element == Constants.myName);
                  return InkWell(
                    onTap: () {
                      if (snt[index].data()['sendBy'] != Constants.myEmail) {
                        Map<String, dynamic> upDatedRead = {
                          'readed': 1,
                        };
                        _data.updateLastMessageSend(
                            snt[index].data()['chatroomId'], upDatedRead);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationScreen(
                                chatRoomId: chatRoom, User: list[0]),
                          ));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox.fromSize(
                          size: const Size(55, 55),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                    colors: [
                                      Color((math.Random().nextDouble() *
                                                  0xFFFFFF)
                                              .toInt())
                                          .withOpacity(1.0),
                                      Colors.lightBlue
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight)),
                            child: Center(
                              child: Text(
                                list[0].toString().split(' ').last,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  list[0].toString().trimLeft(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Text(
                                    showTime(lastMs: dateTime),
                                    style: TextStyle(
                                        color: checkRead(
                                                sendBy:
                                                    snt[index].data()["sendBy"],
                                                read:
                                                    snt[index].data()["readed"])
                                            ? Colors.black54
                                            : Colors.black,
                                        fontWeight: checkRead(
                                                sendBy:
                                                    snt[index].data()["sendBy"],
                                                read:
                                                    snt[index].data()["readed"])
                                            ? FontWeight.w300
                                            : FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${snt[index].data()["sendBy"] == Constants.myEmail ? 'Bạn: ' : ''}${snt[index].data()["lastMessage"]}",
                              style: TextStyle(
                                  color: checkRead(
                                          sendBy: snt[index].data()["sendBy"],
                                          read: snt[index].data()["readed"])
                                      ? Colors.black54
                                      : Colors.black,
                                  fontWeight: checkRead(
                                          sendBy: snt[index].data()["sendBy"],
                                          read: snt[index].data()["readed"])
                                      ? FontWeight.w400
                                      : FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        )),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Container(
                  padding: const EdgeInsets.only(left: 70),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: Colors.black12,
                  ),
                ),
                itemCount: snt.length,
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
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
    if (day(currentTime) == day(lastMs)) {
      return DateFormat('hh:mm').format(lastMs);
    } else {
      return DateFormat('hh:mm, d TM').format(lastMs);
    }
  }
}
