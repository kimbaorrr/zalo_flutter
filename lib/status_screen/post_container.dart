import 'package:flutter/material.dart';
import '/Auth/Service/constant.dart';
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
      avatarUrl: Constants.myAvatar,
    );
  }

  String calculateTimeAgo(int time) {
    DateTime now = DateTime.now();
    DateTime t = DateTime.fromMillisecondsSinceEpoch(time);
    Duration diff = now.difference(t);
    if (diff.inMinutes < 1) {
      return "${diff.inSeconds} giây trước";
    }
    if (diff.inHours < 1) {
      return "${diff.inMinutes} phút trước";
    }
    if (diff.inDays < 1) {
      return "${diff.inHours} giờ trước";
    }
    if (diff.inDays >= 1) {
      return "${diff.inDays} ngày trước";
    }
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
                      avatarUrl: avatarUrl,
                      name: name,
                      time_ago: calculateTimeAgo(time)),
                  const SizedBox(height: 4.0),
                  Text(caption),
                  imageUrl != ""
                      ? const SizedBox.shrink()
                      : const SizedBox(height: 6.0),
                ],
              ),
            ),
            imageUrl != ""
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
      {required this.avatarUrl, required this.name, required this.time_ago});

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
          icon: const Icon(Icons.more_horiz),
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
              ? const Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
          label: const Text(''),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.comment,
            color: Colors.black,
          ),
          label: const Text(''),
        ),
      ],
    );
  }
}
