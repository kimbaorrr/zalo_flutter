import 'package:flutter/material.dart';
import 'package:zalo/Auth/Profile/profile_screen.dart';
import 'package:zalo/home_screen/home_screen.dart';
import 'package:zalo/widgets/common_widget.dart';
import '/Auth/StartPage.dart';
import '/Auth/Service/auth_service.dart';
import 'custom_item_card.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AuthService _authService = AuthService();
  List<Data> datas = [];
  @override
  void initState() {
    super.initState();

    datas = [
      Data(title: 'Quyền riêng tư', icon: Icons.lock, onPressed: (context) {}),
      Data(
        title: 'Tài khoản và bảo mật',
        icon: Icons.security,
        onPressed: (context) {},
      ),
      Data(
        title: 'Sao lưu & đồng bộ tin nhắn',
        icon: Icons.cloud,
        onPressed: (context) {},
      ),
      Data(
        title: 'Giao diện',
        icon: Icons.brush,
        onPressed: (context) {},
      ),
      Data(
        title: 'Thông báo',
        icon: Icons.notifications,
        onPressed: (context) {},
      ),
      Data(
        title: 'Tin nhắn',
        icon: Icons.message,
        onPressed: (context) {},
      ),
      Data(title: 'Cuộc gọi', icon: Icons.call, onPressed: (context) {}),
      Data(
        title: 'Quản lý dữ liệu & bộ nhớ',
        icon: Icons.storage,
        onPressed: (context) {},
      ),
      Data(
        title: 'Nhật ký và khoảnh khắc',
        icon: Icons.watch_later,
        onPressed: (context) {},
      ),
      Data(
        title: 'Danh bạ',
        icon: Icons.contacts,
        onPressed: (context) {},
      ),
      Data(
        title: 'Ngôn ngữ và phông chữ',
        icon: Icons.text_format,
        onPressed: (context) {},
      ),
      Data(
        title: 'Thông tin về Zalo',
        icon: Icons.info,
        onPressed: (context) {},
      ),
      Data(
        title: 'Chuyển tài khoản',
        icon: Icons.swap_horiz,
        onPressed: (context) {},
      ),
      Data(
        title: 'Đăng xuất',
        icon: Icons.logout,
        onPressed: (context) async {
          await _authService.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StartPage()),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Cài đặt", const HomeScreen()),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: datas.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    GestureDetector(
                      child: CustomItemCard(
                          isShowRightIcon: true,
                          icon: datas[index].icon,
                          title: datas[index].title,
                          isMargin: true,
                          isShowDivider: true),
                      onTap: () => datas[index].onPressed(context),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Data {
  final IconData icon;
  final String title;
  final Function(BuildContext) onPressed;
  Data({required this.icon, required this.title, required this.onPressed});
}
