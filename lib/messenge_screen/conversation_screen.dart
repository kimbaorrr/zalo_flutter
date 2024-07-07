import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_myapp/Auth/Service/constant.dart';
import 'package:flutter_myapp/Auth/Service/database.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String User;

  const ConversationScreen(
      {Key? key, required this.chatRoomId, required this.User})
      : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> chatMessagesStream =
      databaseMethods.getConversationMessage(widget.chatRoomId);
  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    messageController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  Widget chatMessageList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: chatMessagesStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                reverse: true,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot
                        .data!.docs[snapshot.data!.docs.length - index - 1]
                        .data()['message'],
                    isSendByMe: snapshot
                            .data!.docs[snapshot.data!.docs.length - index - 1]
                            .data()["sendBy"] ==
                        Constants.myEmail,
                    time: snapshot
                        .data!.docs[snapshot.data!.docs.length - index - 1]
                        .data()['time'],
                    checkTime: (snapshot.data!
                                .docs[snapshot.data!.docs.length - index - 1]
                                .data()['time'] -
                            snapshot.data!
                                .docs[snapshot.data!.docs.length - index - 1]
                                .data()['time']) >=
                        60000,
                  );
                })
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      var message = messageController.text;
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myEmail,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods
          .addConversationMessage(widget.chatRoomId, messageMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "readed": 0,
          "sendBy": Constants.myEmail,
          "time": DateTime.now().millisecondsSinceEpoch,
          "time2": DateTime.now().millisecondsSinceEpoch,
        };
        databaseMethods.updateLastMessageSend(
            widget.chatRoomId, lastMessageInfoMap);
      });
      messageController.text = "";
    }
  }

  @override
  void initState() {
    chatMessagesStream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.User,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(child: chatMessageList()),
          Container(
            // height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
              )
            ]),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () async {
                      await SystemChannels.textInput
                          .invokeMethod('TextInput.hide');
                      await Future.delayed(const Duration(milliseconds: 10));
                      setState(() {
                        emojiShowing = !emojiShowing;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 10));
                      setState(() {
                        emojiShowing = false;
                      });
                    },
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      filled: false,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.lightBlueAccent,
                      size: 30,
                    ))
              ],
            ),
          ),
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
              height: 250,
              child: EmojiPicker(
                  onEmojiSelected: (Category? category, Emoji emoji) {
                    _onEmojiSelected(emoji);
                  },
                  onBackspacePressed: _onBackspacePressed,
                  config: Config(
                      columns: 7,
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      initCategory: Category.RECENT,
                      bgColor: const Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      recentsLimit: 28,
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL)),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe, checkTime;
  final int time;

  MessageTile(
      {required this.message,
      required this.isSendByMe,
      required this.time,
      required this.checkTime});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        margin: isSendByMe
            ? const EdgeInsets.only(left: 80)
            : const EdgeInsets.only(right: 80),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xffa2c0dc), const Color(0xff70b0ee)]
                    : [
                        const Color(0xffd9e1e7),
                        const Color(0xffd9e1e7),
                      ]),
            borderRadius: isSendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              showTime(lastMs: dateTime),
              style: const TextStyle(color: Colors.black54, fontSize: 10),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  String showTime({required DateTime lastMs}) {
    if (day(DateTime.now()) == day(lastMs)) {
      return DateFormat('hh:mm').format(lastMs);
    } else {
      return DateFormat('hh:mm, d TM').format(lastMs);
    }
  }

  String day(DateTime dateTime) {
    return DateFormat('dd:MM:yyyy').format(dateTime);
  }
}
