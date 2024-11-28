import 'package:flutter/material.dart';
import '/Auth/Service/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostContainer extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final int time;
  final String caption;
  final String imageUrl;

  const PostContainer({
    super.key,
    required this.caption,
    required this.avatarUrl,
    required this.time,
    required this.imageUrl,
    required this.name,
  });

  factory PostContainer.fromDocument({required DocumentSnapshot doc}) {
    return PostContainer(
      caption: doc["description"],
      name: Constants.myName,
      imageUrl: doc["mediaUrl"],
      time: doc["time"],
      avatarUrl: Constants.myAvatar,
    );
  }

  String _calculateTimeAgo(int time) {
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
                  _buildPostHeader(avatarUrl, name, _calculateTimeAgo(time)),
                  const SizedBox(height: 4.0),
                  Text(caption),
                  imageUrl != ""
                      ? const SizedBox.shrink()
                      : const SizedBox(height: 6.0),
                ],
              ),
            ),
            _buildPostImage(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: _PostStats(),
            )
          ],
        ));
  }

  Widget _buildProfileAvatar(String imageUrl) {
    return CircleAvatar(
      radius: 20.0,
      backgroundColor: Colors.grey[200],
      backgroundImage: NetworkImage(imageUrl),
    );
  }

  Widget _buildPostHeader(String avatar, String name, String timeAgo) {
    return Row(
      children: [
        _buildProfileAvatar(avatar),
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
                timeAgo,
                style: TextStyle(color: Colors.grey.shade600),
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

  Widget _buildPostImage() {
    if (imageUrl != "") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Image.network(imageUrl),
      );
    } else {
      return const SizedBox.shrink();
    }
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
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
                )
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.comment,
            color: Colors.black,
          )
        ),
      ],
    );
  }
}
