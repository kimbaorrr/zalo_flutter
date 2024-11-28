import 'package:flutter/material.dart';
import '/Auth/Service/constant.dart';
import '/Auth/modals/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Users? users;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: Column(mainAxisSize: MainAxisSize.max, children: [
        _buildInforProfile(),
        _divider(),
        _cardBig(
            icon: Icons.qr_code,
            title: 'Ví Qr',
            content: 'Lưu trữ và xuất trình các mã QR quan trọng'),
        _divider(),
        _cardBig(
            icon: Icons.cloud_outlined,
            title: 'Cloud của tôi',
            content: 'Lưu trữ các tin nhắn quan trọng'),
        _divider(),
        _cardSmall(
            icon1: Icons.shield_outlined,
            icon2: Icons.lock,
            title1: 'Tài khoản và bảo mật',
            title2: 'Quyền riêng tư'),
        Expanded(
          child: Container(
            color: Colors.grey.withOpacity(0.3),
          ),
        )
      ]),
    );
  }

  Widget _buildInforProfile() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              Constants.myAvatar,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Constants.myName,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Xem trang cá nhân',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardBig(
      {required IconData icon,
      required String title,
      required String content}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                content,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardSmall(
      {required IconData icon1,
      required IconData icon2,
      required String title1,
      required String title2}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon1,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    title1,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.black54,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _dividerMini(),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon2,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    title2,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.black54,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Divider _divider() {
    return Divider(
      color: Colors.grey.withOpacity(0.3),
      height: 10,
      thickness: 8,
    );
  }

  Widget _dividerMini() {
    return Container(
      margin: const EdgeInsets.only(left: 44),
      child: Divider(
        color: Colors.grey.withOpacity(0.3),
        thickness: 0.5,
      ),
    );
  }
}
