import 'package:flutter/material.dart';

class PostFooter extends StatefulWidget {
  final bool isOpen;
  final Color color;
  final String title;
  final Function openCloser;
  final IconData icon;
  const PostFooter({
    super.key,
    required this.isOpen,
    required this.icon,
    required this.color,
    required this.title,
    required this.openCloser,
  });

  @override
  State<PostFooter> createState() => _PostFooterState();
}

class _PostFooterState extends State<PostFooter> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: widget.isOpen ? widget.color : Colors.white,
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
                  color: widget.isOpen ? widget.color : Colors.white,
                  size: 26,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
