import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zalo/common.dart';
import '/Auth/Service/constant.dart';
import '/Auth/Service/database.dart';
import '/Auth/modals/user.dart';
import '/messenge_screen/conversation_screen.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Stream? userStream;
  List<Users> listUsers = [];
  Users? user;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
  }

  _createChatRoomAndStartConversation(
      {required String userEmail, required String userName}) async {
    if (userEmail != Constants.myEmail) {
      String chatRoomId = getChatRoomId(userEmail, Constants.myEmail);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "lastMessage": '',
        "sendBy": '',
        "readed": 0,
        "time": 0,
        "time2": 0,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTabs(),
            if (selectedTab == 0) ...[
              _buildButtonsofFriendTab(),
              _buildUserList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color:
                          selectedTab == i ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  )),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTab = i;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          selectedTab == i ? Colors.black : Colors.grey,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      i == 0
                          ? "Bạn bè"
                          : i == 1
                              ? "Nhóm"
                              : "OA",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: selectedTab == i
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ));
  }

  Widget _buildButtonsofFriendTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            minimumSize: const Size(100, 60),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue,
                ),
                child: const Icon(
                  Icons.contact_support_sharp,
                  color: Colors.white,
                ),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Lời mời kết bạn",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            minimumSize: const Size(100, 60),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue,
                ),
                child: const Icon(
                  Icons.contact_page,
                  color: Colors.white,
                ),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Danh bạ máy",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            minimumSize: const Size(100, 60),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue,
                ),
                child: const Icon(
                  Icons.cake,
                  color: Colors.white,
                ),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Lịch sinh nhật",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Users>>(
      stream: DatabaseMethods().getAllUsers(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          );
        }
        if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Không có người dùng nào!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return _buildUserListView(userSnapshot.data!);
      },
    );
  }

  Widget _buildUserListView(List<Users> users) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      itemCount: users.length,
      itemBuilder: (context, index) {
        Users user = users[index];
        return _buildUserItem(user);
      },
    );
  }

  Widget _buildUserItem(Users user) {
    if (user.email.replaceAll('@gmail.com', '') == Constants.myEmail) {
      return Container();
    }

    return InkWell(
        onTap: () {
          _createChatRoomAndStartConversation(
            userEmail: user.email.replaceAll("@gmail.com", ""),
            userName: user.name,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox.fromSize(
                  size: const Size(55, 55),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(user.avatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.videocam),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ));
  }
}
