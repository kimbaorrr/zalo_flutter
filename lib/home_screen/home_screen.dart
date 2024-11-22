import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zalo/widgets/custom_alert_dialog.dart';
import '/Auth/StartPage.dart';
import '/Auth/Service/constant.dart';
import '/Auth/Service/database.dart';
import '/Auth/Service/helper_function.dart';
import '/Auth/Profile/profile_screen.dart';
import '/Auth/Profile/setting_screen.dart';
import '/Auth/modals/user.dart';
import '/contact_screen/contact_screen.dart';
import '/messenge_screen/conversation_screen.dart';
import '/messenge_screen/messenge_screen.dart';
import '/status_screen/status_screen.dart';
import '/widgets/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  final List<Widget> _widgetOptions = [
    const MessageScreen(),
    const ContactScreen(),
    const StatusScreen(),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      pageController.jumpToPage(index);
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    getAllUser();
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName =
        await HelperFunctions.getUserNameSharedPreference() ?? "";
    Constants.myEmail =
        await HelperFunctions.getUserEmailSharedPreference() ?? "";
    Constants.myAvatar =
        await HelperFunctions.getUserAvatarSharedPreference() ?? "";
    if (Constants.myName.isEmpty || Constants.myEmail.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StartPage()),
      );
      return;
    }
    setState(() {});
  }

  Future<List<Users>> getAllUser() async {
    listUsers.clear();
    return await usersRef.get().then((users) {
      for (final DocumentSnapshot<Map<String, dynamic>> doc in users.docs) {
        listUsers.add(Users.fromDocumentSnapshot(doc: doc));
        listUsers.removeWhere((element) =>
            element.email.replaceAll("@gmail.com", '') == Constants.myEmail);
      }
      return listUsers.isEmpty ? List.empty() : listUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          child: const Icon(
            Icons.search_outlined,
            color: Colors.white,
            size: 32,
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(left: 0),
          child: CustomTextFieldNonBorder(
            hintText: 'Tìm kiếm bạn bè . . .',
            readOnly: true,
            onTapTextField: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ),
        actions: [
          _selectedIndex == 3
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingScreen()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(Icons.settings, color: Colors.white),
                  ))
              : _selectedIndex == 0
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.qr_code_scanner_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 35,
                          ),
                        ],
                      ),
                    )
                  : _selectedIndex == 2
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Icon(Icons.image_search,
                                  color: Colors.white, size: 30),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ],
                          ),
                        )
                      : _selectedIndex == 1
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.person_add_alt,
                                color: Colors.white,
                                size: 30,
                              ),
                            )
                          : Container(),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: _onItemTapped,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Tin nhắn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone),
            label: 'Danh bạ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse_sharp),
            label: 'Nhật kí',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedLabelStyle: const TextStyle(
            color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 13),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomSearchDelegate extends SearchDelegate {
  List<Users> searchItem = listUsers;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.black87,
          ))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black87,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Users> matchQuery = [];
    for (var i in searchItem) {
      if (i.name.toLowerCase().contains(query.toLowerCase()) ||
          i.email.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(i);
      }
    }
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      itemCount: matchQuery.length >= 5 ? 5 : matchQuery.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => UserCard(
                avatarUrl: Constants.myAvatar,
                userName: result.name,
                userEmail: result.email.replaceAll("@gmail.com", ""),
                isFriend: result.friends.contains(result.name),
              ),
            );
          },
          child: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: SizedBox.fromSize(
                    size: const Size(60, 60),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(result.avatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            result.email.replaceAll("@gmail.com", ''),
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Users> matchQuery = [];
    for (var i in searchItem) {
      if (i.name.toLowerCase().contains(query.toLowerCase()) ||
          i.email.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(i);
      }
    }
    print(searchItem.toString());
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      itemCount: matchQuery.length >= 5 ? 5 : matchQuery.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => UserCard(
                  avatarUrl: Constants.myAvatar,
                  userName: result.name,
                  userEmail: result.email.replaceAll("@gmail.com", ""),
                  isFriend: result.friends.contains(result.name)),
            );
          },
          child: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: SizedBox.fromSize(
                    size: const Size(60, 60),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(result.avatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          result.email.replaceAll("@gmail.com", ''),
                          style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

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

  Future<void> addOrRemoveFriend() async {
    bool result = await DatabaseMethods()
        .addOrRemoveFriend(!widget.isFriend, Constants.myName, widget.userName);

    if (result) {
      setState(() {
        widget.isFriend = !widget.isFriend;
      });
    }
  }

  getChatRoomId(String a, String b) {
    if (int.parse(a) > int.parse(b)) {
      return "${a}_$b";
    } else {
      return "${b}_$a";
    }
  }

  createChatRoomAndStartConversation(
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    createChatRoomAndStartConversation(context,
                        userEmail:
                            widget.userEmail.replaceAll("@gmail.com", ""),
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
                  onPressed: addOrRemoveFriend,
                  icon: Icon(
                      widget.isFriend ? Icons.person_remove : Icons.person_add),
                  label: Text(widget.isFriend ? 'Hủy kết bạn' : 'Kết bạn'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
