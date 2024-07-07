import 'package:flutter/material.dart';
import 'package:flutter_myapp/Auth/Service/auth_service.dart';
import 'package:flutter_myapp/Auth/Service/helper_function.dart';
import 'package:flutter_myapp/Auth/SignOut/custom_item_card.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

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
        title: 'Sao lưu và khôi phục',
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
        title: 'Quản lý dữ liệu và bộ nhớ',
        icon: Icons.pie_chart,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Cuộc gọi', icon: Icons.call, onPressed: () {}, isMargin: false),
    Data(
        title: 'Nhật ký và khoảnh khắc',
        icon: Icons.watch_later,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Danh bạ',
        icon: Icons.person,
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
        icon: Icons.people,
        onPressed: () {},
        isMargin: false),
    Data(
        title: 'Logout',
        icon: Icons.logout,
        onPressed: () async {
          //await authService.signOut();
        },
        isMargin: false),
  ];
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context); //NDL Long add
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Setting'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.navigate_before,
                size: 35,
              ))),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: datas.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () async {
                        if (index == datas.length - 1) {
                          await authService.signOut();
                          await HelperFunctions.saveUserEmailSharedPreference(
                              '');
                          await HelperFunctions.saveUserNameSharedPreference(
                              '');
                          print('xong');
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/signin", (r) => false);
                        }
                      },
                      child: CutomItemCart(
                        isShowRightIcon: true,
                        icon: datas[index].icon,
                        title: datas[index].title,
                        isMargin: datas[index].isMargin,
                        isShowDivider: !datas[index].isMargin,
                      ));
                }),
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
  Data(
      {required this.icon,
      required this.title,
      required this.onPressed,
      required this.isMargin});
}
