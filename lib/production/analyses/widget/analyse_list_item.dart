import 'package:farmdriverzootech/production/analyses/widget/view_pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AnalyseListItem extends StatelessWidget {
  final Map analyse;
  const AnalyseListItem({super.key, required this.analyse});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColorLight.withOpacity(0.2)),
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: ClipOval(
          child: Container(
            color: Colors.amber,
            width: 50,
            height: 50,
            child: Center(child: FittedBox(child: Text(analyse["doctor"]))),
          ),
        ),
        title: Text(
          analyse["name"],
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          analyse["formated_date"],
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
        trailing: SizedBox(
          width: 60,
          height: 26,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
              backgroundColor: Colors.amber,
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 300),
                  child: ViewPdfScreen(
                    pdfUrl: analyse["file"],
                    name: analyse["name"],
                  ),
                ),
              );
            },
            child: const Icon(
              Icons.remove_red_eye_sharp,
              size: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
