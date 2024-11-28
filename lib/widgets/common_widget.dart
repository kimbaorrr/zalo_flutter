import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(
    BuildContext context, String text, Widget backPage) {
  return AppBar(
    backgroundColor: Colors.blue,
    elevation: 0,
    title: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => backPage),
      ),
    ),
  );
}

Widget buildLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(
      color: Colors.blue,
    ),
  );
}
