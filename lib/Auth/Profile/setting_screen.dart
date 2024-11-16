import 'package:flutter/material.dart';
import '/Auth/StartPage.dart';
import '/Auth/Service/auth_service.dart';
import 'custom_item_card.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<Data> datas = [
    Data(
        title: 'Quyền riêng tư',
        icon: Icons.lock,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Tài khoản và bảo mật',
        icon: Icons.security,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Sao lưu & đồng bộ tin nhắn',
        icon: Icons.cloud,
        onPressed: () {},
        isMargin: true),
    Data(
        title: 'Giao diện',
        icon: Icons.brush,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Thông báo',
        icon: Icons.notifications,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Tin nhắn',
        icon: Icons.message,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Cuộc gọi', icon: Icons.call, onPressed: () {}, isMargin: false),
    Data(
        title: 'Quản lý dữ liệu & bộ nhớ',
        icon: Icons.storage,
        onPressed: () {},
        isMargin: true),
    Data(
        title: 'Nhật ký và khoảnh khắc',
        icon: Icons.watch_later,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Danh bạ',
        icon: Icons.contacts,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Ngôn ngữ và phông chữ',
        icon: Icons.text_format,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Thông tin về Zalo',
        icon: Icons.info,
        onPressed: () {},
        isMargin: true),
    Data(
        title: 'Chuyển tài khoản',
        icon: Icons.swap_horiz,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Đăng xuất',
        icon: Icons.logout,
        onPressed: () async {
          //await authService.signOut();
        },
        isMargin: false),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.blue),
        ),
        elevation: 0,
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: datas.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    if (datas[index].isMargin)
                      const Divider(
                        thickness: 8,
                        color: Colors.grey,
                      ),
                    GestureDetector(
                      onTap: () async {
                        if (index == datas.length - 1) {
                          await authService.signOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StartPage()),
                          );
                        }
                      },
                      child: CustomItemCard(
                        isShowRightIcon: true,
                        icon: datas[index].icon,
                        title: datas[index].title,
                        isMargin: datas[index].isMargin,
                        isShowDivider: !datas[index].isMargin,
                      ),
                    ),
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
  IconData icon;
  String title;
  Function onPressed;
  bool isMargin;
  Data({
    required this.icon,
    required this.title,
    required this.onPressed,
    required this.isMargin,
  });
}
