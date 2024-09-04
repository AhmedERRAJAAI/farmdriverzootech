import 'package:flutter/material.dart';

class RecentSuppAnalyseItem extends StatelessWidget {
  final IconData icon;
  final bool isSupp;
  final String text;
  final String date;
  const RecentSuppAnalyseItem({super.key, required this.icon, required this.isSupp, required this.text, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white),
            child: Icon(
              icon,
              color: isSupp ? Colors.blue : Colors.lightGreen,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(text),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
