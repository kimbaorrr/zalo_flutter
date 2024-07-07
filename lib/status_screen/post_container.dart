import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myapp/Auth/Service/constant.dart';
import 'profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostContainer extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final int time;
  final String caption;
  final String imageUrl;

  const PostContainer({
    Key? key,
    required this.caption,
    required this.avatarUrl,
    required this.time,
    required this.imageUrl,
    required this.name,
  }) : super(key: key);
  factory PostContainer.fromDocument({required DocumentSnapshot doc}) {
    return PostContainer(
      caption: doc["description"],
      name: Constants.myName,
      imageUrl: doc["mediaUrl"],
      time: doc["time"],
      avatarUrl:
          'https://scr.vn/wp-content/uploads/2020/08/%E1%BA%A2nh-hot-girl-l%C3%A0m-avt.jpg',
    );
  }
  String calculateTimeAgo(int time) {
    DateTime now = DateTime.now();
    DateTime t = DateTime.fromMillisecondsSinceEpoch(time);
    Duration diff = now.difference(t);
    if (diff.inMinutes < 1)
      return diff.inSeconds.toString() + " giây trước";
    else if (diff.inHours < 1)
      return diff.inMinutes.toString() + " phút trước";
    else if (diff.inDays < 1)
      return diff.inHours.toString() + " giờ trước";
    else if (diff.inDays >= 1) return diff.inDays.toString() + " ngày trước";
    return diff.inMinutes.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PostHeader(
                      avatarUrl: this.avatarUrl,
                      name: this.name,
                      time_ago: this.calculateTimeAgo(this.time)),
                  const SizedBox(height: 4.0),
                  Text(caption),
                  imageUrl != null
                      ? const SizedBox.shrink()
                      : const SizedBox(height: 6.0),
                ],
              ),
            ),
            imageUrl != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.network(imageUrl),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: _PostStats(),
            )
          ],
        ));
  }
}

class _PostHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String time_ago;

  const _PostHeader(
      {Key? key,
      required this.avatarUrl,
      required this.name,
      required this.time_ago})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(imageUrl: avatarUrl),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                time_ago,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_horiz),
        ),
      ],
    );
  }
}

class _PostStats extends StatefulWidget {
  @override
  State<_PostStats> createState() => _PostStatsState();
}

class _PostStatsState extends State<_PostStats> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              liked = !liked;
            });
          },
          icon: !liked
              ? Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                )
              : Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
          label: Text(''),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.comment,
            color: Colors.black,
          ),
          label: Text(''),
        ),
      ],
    );
  }
}
