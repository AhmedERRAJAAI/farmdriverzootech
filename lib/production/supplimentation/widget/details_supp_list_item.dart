import 'package:flutter/material.dart';

class DetailsSuppListItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const DetailsSuppListItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  color: Colors.green.shade400,
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    size: 16,
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(label)
            ],
          ),
          Text(value)
        ],
      ),
    );
  }
}
