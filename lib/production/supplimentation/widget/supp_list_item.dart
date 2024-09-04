import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../supplimentation_details.dart';

class SuppListItem extends StatelessWidget {
  final String product;
  final String familly;
  final String date;
  final Map suppItem;
  const SuppListItem({super.key, required this.product, required this.familly, required this.date, required this.suppItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(color: Theme.of(context).primaryColorLight.withOpacity(0.2)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300),
              child: SupplimentaionDetails(singleSupplimentation: suppItem),
            ),
          );
        },
        leading: ClipOval(
          child: Container(
            color: Colors.teal.shade400,
            width: 50,
            height: 50,
            child: Icon(
              MdiIcons.testTube,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          product,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          familly,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
        trailing: Text(date),
      ),
    );
  }
}
