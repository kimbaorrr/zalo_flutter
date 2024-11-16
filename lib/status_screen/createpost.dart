import 'package:flutter/material.dart';
import '/status_screen/upload_page.dart';

class CreatePostContainer extends StatelessWidget {
  const CreatePostContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.grey[200],
                backgroundImage: const NetworkImage(
                    'https://t4.ftcdn.net/jpg/03/83/25/83/360_F_383258331_D8imaEMl8Q3lf7EKU2Pi78Cn0R7KkW9o.jpg'),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadPage()),
                    );
                  },
                  // decoration: InputDecoration.collapsed(hintText: 'Hôm nay bạn thế nào'),
                  child: const Text(
                    'Hôm nay bạn thế nào?', //title
                    textAlign: TextAlign.left, //aligment
                  ),
                ),
              )
            ],
          ),
          const Divider(height: 10.0, thickness: 0.5),
          SizedBox(
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.image,
                    color: Colors.green,
                  ),
                  label: const Text('Đăng ảnh'),
                ),
                const VerticalDivider(width: 8.0),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.videocam,
                    color: Colors.red,
                  ),
                  label: const Text('Đăng video'),
                ),
                const VerticalDivider(width: 8.0),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.photo_album,
                    color: Colors.blue,
                  ),
                  label: const Text('Tạo album'),
                ),
                const VerticalDivider(width: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
