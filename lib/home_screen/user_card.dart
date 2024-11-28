import 'package:flutter/material.dart';
import 'package:zalo/Auth/Service/constant.dart';
import 'package:zalo/Auth/Service/database.dart';
import 'package:zalo/common.dart';
import 'package:zalo/messenge_screen/conversation_screen.dart';

class UserCard extends StatefulWidget {
  final String avatarUrl;
  final String userName;
  final String userEmail;
  late bool isFriend;

  UserCard(
      {super.key,
      required this.avatarUrl,
      required this.userName,
      required this.userEmail,
      required this.isFriend});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _addOrRemoveFriend() async {
    bool result = await DatabaseMethods()
        .addOrRemoveFriend(!widget.isFriend, Constants.myName, widget.userName);

    if (result) {
      setState(() {
        widget.isFriend = !widget.isFriend;
      });
    }
  }

  _createChatRoomAndStartConversation(
    BuildContext context, {
    required String userEmail,
    required String userName,
  }) async {
    if (userEmail != Constants.myEmail) {
      String chatRoomId = getChatRoomId(userEmail, Constants.myEmail);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);

      print(Constants.myName);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                    User: userName,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(),
            const SizedBox(height: 20),
            _buildActionButton()
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(widget.avatarUrl),
        ),
        const SizedBox(height: 10),
        Text(
          widget.userName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            _createChatRoomAndStartConversation(context,
                userEmail: widget.userEmail.replaceAll("@gmail.com", ""),
                userName: widget.userName);
          },
          icon: const Icon(Icons.message),
          label: const Text('Nhắn tin'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade600,
            foregroundColor: Colors.white,
          ),
        ),
        ElevatedButton.icon(
          onPressed: _addOrRemoveFriend,
          icon: Icon(widget.isFriend ? Icons.person_remove : Icons.person_add),
          label: Text(widget.isFriend ? 'Hủy kết bạn' : 'Kết bạn'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
