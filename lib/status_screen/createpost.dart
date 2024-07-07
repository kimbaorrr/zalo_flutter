import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/status_screen/upload_page.dart';

class CreatePostContainer extends StatelessWidget {
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
                backgroundImage: NetworkImage(
                    'https://scr.vn/wp-content/uploads/2020/08/%E1%BA%A2nh-hot-girl-l%C3%A0m-avt.jpg'),
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
                  child: Text(
                    'Hôm nay bạn thế nào?', //title
                    textAlign: TextAlign.left, //aligment
                  ),
                ),
              )
            ],
          ),
          const Divider(height: 10.0, thickness: 0.5),
          Container(
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
                  label: Text('Đăng ảnh'),
                ),
                const VerticalDivider(width: 8.0),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.videocam,
                    color: Colors.red,
                  ),
                  label: Text('Đăng video'),
                ),
                const VerticalDivider(width: 8.0),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.photo_album,
                    color: Colors.blue,
                  ),
                  label: Text('Tạo album'),
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
