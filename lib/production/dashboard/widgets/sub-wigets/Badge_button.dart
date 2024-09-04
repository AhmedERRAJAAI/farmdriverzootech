import 'package:flutter/material.dart';

class BadgeButton extends StatefulWidget {
  final IconData icon;
  final Function callBackFun;
  const BadgeButton({
    super.key,
    required this.icon,
    required this.callBackFun,
  });

  @override
  State<BadgeButton> createState() => _BadgeButtonState();
}

class _BadgeButtonState extends State<BadgeButton> {
  int notificationCount = 6;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(top: 9.3, right: 8),
              child: Icon(widget.icon, color: Colors.grey.shade600),
            ),
            onTap: () {
              widget.callBackFun();
            },
          ),
          if (notificationCount > 0)
            Positioned(
              right: 0,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: const BoxConstraints(
                  minWidth: 15,
                  minHeight: 15,
                ),
                child: Center(
                  child: Text(
                    notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
