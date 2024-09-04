import 'package:flutter/material.dart';

class DetailsTableRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const DetailsTableRow({super.key, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
