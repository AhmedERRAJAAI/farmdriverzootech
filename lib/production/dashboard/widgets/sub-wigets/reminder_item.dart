import 'package:farmdriverzootech/farmdriver_base/src/memento/memento_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';

class ReminderItem extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String time;
  const ReminderItem({super.key, required this.title, required this.content, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            child: const MementoScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                Text(
                  date,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                )
              ],
            ),
            const SizedBox(height: 6),
            ReadMoreText(
              content,
              textAlign: TextAlign.left,
              trimMode: TrimMode.Line,
              trimLines: 1,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              trimCollapsedText: ' Voir plus',
              trimExpandedText: ' voir moins',
              moreStyle: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.normal),
              lessStyle: const TextStyle(fontSize: 12, color: Colors.purpleAccent, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
