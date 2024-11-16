import 'package:flutter/material.dart';
import '/status_screen/upload_page.dart';

class CreatePostContainer extends StatelessWidget {
  const CreatePostContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://t4.ftcdn.net/jpg/03/83/25/83/360_F_383258331_D8imaEMl8Q3lf7EKU2Pi78Cn0R7KkW9o.jpg',
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UploadPage()),
                      );
                    },
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Hôm nay bạn thế nào?',
                        hintStyle: const TextStyle(color: Colors.black54),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      color: Colors.green,
                    ),
                    label: const Text('Đăng ảnh'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.videocam,
                      color: Colors.red,
                    ),
                    label: const Text('Đăng video'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.photo_album,
                      color: Colors.blue,
                    ),
                    label: const Text('Tạo album'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.access_time_rounded,
                      color: Colors.amber,
                    ),
                    label: const Text('Kỷ niệm'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
