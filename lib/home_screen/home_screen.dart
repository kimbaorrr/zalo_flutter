import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zalo/Auth/Profile/setting_screen.dart';
import 'package:zalo/home_screen/search_bar.dart';
import '/Auth/StartPage.dart';
import '/Auth/Service/constant.dart';
import '/Auth/Service/database.dart';
import '/Auth/Service/helper_function.dart';
import '/Auth/Profile/profile_screen.dart';
import '/Auth/modals/user.dart';
import '/contact_screen/contact_screen.dart';
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
    _getAllUser();
    _getUserInfo();
    super.initState();
  }

  _getUserInfo() async {
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

  Future<List<Users>> _getAllUser() async {
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
            size: 28,
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(left: 0),
          child: CustomTextFieldNonBorder(
            hintText: 'Tìm kiếm',
            readOnly: true,
            onTapTextField: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ),
        actions: [_buildRightAppBar(_selectedIndex)],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: _onItemTapped,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Tin nhắn'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone), label: 'Danh bạ'),
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
            color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildRightAppBar(int selectedIndex) {
    List<IconData> icons = [
      Icons.qr_code_scanner_outlined,
      Icons.person_add_alt,
      Icons.notifications_none_outlined,
      Icons.settings
    ];
    List<dynamic> nextPages = [
      const HomeScreen(),
      const HomeScreen(),
      const HomeScreen(),
      const SettingScreen(),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => nextPages[selectedIndex]),
                    ),
                  },
              icon: Icon(
                icons[selectedIndex],
                color: Colors.white,
                size: 28,
              ))
        ],
      ),
    );
  }
}
