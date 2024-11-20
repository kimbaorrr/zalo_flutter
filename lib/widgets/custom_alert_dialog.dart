import 'package:flutter/material.dart';

Future<void> showAlertDialog(
    BuildContext context, bool success, String message) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            !success
                ? const Icon(Icons.error_outline, color: Colors.red, size: 28)
                : const Icon(Icons.add_alert_sharp,
                    color: Colors.grey, size: 28),
            const SizedBox(width: 10),
            Text(
              success ? "Thông báo" : "Lỗi",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          textAlign: TextAlign.justify,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: success ? Colors.blue : Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text(
              "Đồng ý",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      );
    },
  );
}
