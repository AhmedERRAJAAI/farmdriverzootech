import 'package:flutter/material.dart';

class PostHeader extends StatefulWidget {
  final bool isOpen;
  final Color color;
  final String title;
  final Function openCloser;
  final IconData icon;
  const PostHeader({
    super.key,
    required this.icon,
    required this.isOpen,
    required this.color,
    required this.title,
    required this.openCloser,
  });

  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: widget.color,
              ),
            ),
            Icon(
              widget.icon,
              color: widget.isOpen ? widget.color : Colors.white,
            )
          ],
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              widget.openCloser();
            });
          },
          child: Transform.rotate(
            angle: widget.isOpen ? 180 * (3.14159265359 / 180) : 0,
            child: Icon(
              Icons.expand_more,
              color: widget.color,
              size: 26,
            ),
          ),
        )
      ],
    );
  }
}
