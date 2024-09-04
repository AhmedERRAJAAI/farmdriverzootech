import 'package:farmdriverzootech/farmdriver_base/src/edit_notification/provider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../differences_screen.dart';

class NotificationListItem extends StatelessWidget {
  final EditNotification notif;
  const NotificationListItem({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            curve: Curves.bounceIn,
            child: DifferencesScreen(
              modId: notif.modId,
              lot: "${notif.batiment} - ${notif.lotCode}",
              modDate: "${notif.date} - ${notif.time}",
              rapportDate: notif.rapportDate,
              user: notif.user,
              isModif: notif.editType == 2,
            ),
          ),
        );
      },
      leading: ClipOval(
        child: Container(
          width: 40,
          height: 40,
          color: notif.editType == 2 ? Colors.amber : Colors.deepOrange,
          child: Center(
            child: Icon(
              notif.editType == 2 ? Icons.edit : Icons.delete_outline_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
      title: RichText(
        text: TextSpan(
          text: notif.user,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12), // const TextStyle(fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(text: " a ${notif.editType == 2 ? 'modifié' : 'supprimé'}", style: const TextStyle(fontWeight: FontWeight.w400)),
            TextSpan(text: ' le rapport ${notif.rapportDate}, bâtiment', style: const TextStyle(fontWeight: FontWeight.w400)),
            TextSpan(text: ' ${notif.batiment}', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' (${notif.lotCode})', style: const TextStyle(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      subtitle: Text(
        "${notif.date}-${notif.time}",
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
