import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subTitle;
  final bool isShowRightIcon;
  final bool isShowDivider;
  final bool isMargin;
  final Color? subTitleColor;

  const CustomItemCard({
    super.key,
    required this.icon,
    required this.title,
    this.subTitle,
    required this.isShowRightIcon,
    required this.isShowDivider,
    required this.isMargin,
    this.subTitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        bottom: isShowDivider ? 0 : 20,
        right: isShowDivider ? 0 : 20,
      ),
      margin: EdgeInsets.only(bottom: isMargin ? 10 : 0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.blue,
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
                          style: TextStyle(
                            color: subTitleColor ?? Colors.black,
                          ),
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
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: isShowDivider,
            child: Container(
              margin: const EdgeInsets.only(top: 20, left: 45),
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: Colors.blueGrey.shade200,
            ),
          ),
        ],
      ),
    );
  }
}
