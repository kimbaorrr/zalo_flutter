import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:zalo/messenge_screen/message_tile.dart';
import '/Auth/Service/constant.dart';
import '/Auth/Service/database.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String User;

  const ConversationScreen(
      {super.key, required this.chatRoomId, required this.User});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> chatMessagesStream =
      databaseMethods.getConversationMessages(widget.chatRoomId);
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
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(child: _buildChatMessageList()),
          _buildInputMessageField(),
          _buildEmojiPicker(),
        ],
      ),
    );
  }

  Widget _buildInputMessageField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 4,
          )
        ],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: _toggleEmojiPicker,
              icon: const Icon(
                Icons.emoji_emotions,
                color: Colors.blue,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: messageController,
              onTap: _hideEmojiPicker,
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
            onPressed: _sendMessage,
            icon: const Icon(
              Icons.send_rounded,
              color: Colors.lightBlueAccent,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return Offstage(
      offstage: !emojiShowing,
      child: SizedBox(
        height: 250,
        child: EmojiPicker(
          onEmojiSelected: (Category? category, Emoji emoji) {
            _onEmojiSelected(emoji);
          },
          onBackspacePressed: _onBackspacePressed,
          config: const Config(
            height: 256,
            viewOrderConfig: ViewOrderConfig(
              top: EmojiPickerItem.categoryBar,
              middle: EmojiPickerItem.emojiView,
              bottom: EmojiPickerItem.searchBar,
            ),
            skinToneConfig: SkinToneConfig(),
            categoryViewConfig: CategoryViewConfig(),
            bottomActionBarConfig: BottomActionBarConfig(),
            searchViewConfig: SearchViewConfig(),
          ),
        ),
      ),
    );
  }

  void _toggleEmojiPicker() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    await Future.delayed(const Duration(milliseconds: 10));
    setState(() {
      emojiShowing = !emojiShowing;
    });
  }

  void _hideEmojiPicker() async {
    await Future.delayed(const Duration(milliseconds: 10));
    setState(() {
      emojiShowing = false;
    });
  }

  Widget _buildChatMessageList() {
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

  _sendMessage() {
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
}
