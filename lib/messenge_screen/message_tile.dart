import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe, checkTime;
  final int time;

  const MessageTile(
      {super.key,
      required this.message,
      required this.isSendByMe,
      required this.time,
      required this.checkTime});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        margin: isSendByMe
            ? const EdgeInsets.only(left: 80)
            : const EdgeInsets.only(right: 80),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xffa2c0dc), const Color(0xff70b0ee)]
                    : [
                        const Color(0xffd9e1e7),
                        const Color(0xffd9e1e7),
                      ]),
            borderRadius: isSendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              _showTime(lastMs: dateTime),
              style: const TextStyle(color: Colors.black54, fontSize: 10),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  String _showTime({required DateTime lastMs}) {
    if (_day(DateTime.now()) == _day(lastMs)) {
      return DateFormat('hh:mm').format(lastMs);
    } else {
      return DateFormat('hh:mm, d TM').format(lastMs);
    }
  }

  String _day(DateTime dateTime) {
    return DateFormat('dd:MM:yyyy').format(dateTime);
  }
}
