import 'package:flutter/material.dart';
import 'dart:math' as math;

class CutomItemCart extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subTitle;
  final bool isShowRightIcon;
  final bool isMargin;
  final Function? onPressed;
  final bool isShowDivider;
  const CutomItemCart(
      {Key? key,
      required this.icon,
      required this.title,
      this.subTitle,
      this.isMargin = false,
      this.onPressed,
      this.isShowRightIcon = false,
      this.isShowDivider = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.3),
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          bottom: isShowDivider ? 0 : 20,
          right: isShowDivider ? 0 : 20),
      margin: EdgeInsets.only(bottom: isMargin ? 10 : 0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (subTitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 9),
                        child: Text(
                          subTitle ?? '',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Visibility(
                      visible: isShowRightIcon,
                      child: Padding(
                        padding: EdgeInsets.only(right: isShowDivider ? 20 : 0),
                        child: const Icon(
                          Icons.navigate_next,
                          color: Colors.black54,
                        ),
                      )),
                ),
              )
            ],
          ),
          Visibility(
            visible: isShowDivider,
            child: Container(
                margin: const EdgeInsets.only(top: 20, left: 45),
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey),
          )
        ],
      ),
    );
  }
}
