import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.0,
      backgroundColor: Colors.grey[200],
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}
