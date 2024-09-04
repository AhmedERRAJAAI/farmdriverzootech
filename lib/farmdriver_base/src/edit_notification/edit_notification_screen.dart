import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider.dart';
import 'widgets/notification_list_item.dart';

class EditNotificationScreen extends StatefulWidget {
  const EditNotificationScreen({super.key});

  @override
  State<EditNotificationScreen> createState() => _EditNotificationScreenState();
}

class _EditNotificationScreenState extends State<EditNotificationScreen> {
  bool isLoading = false;
  bool failedToFetch = false;
  DateTime? start;
  DateTime? end;

  void startGetter(newVal) {
    setState(() {
      start = newVal;
    });
    fetchEditNotifications(context);
  }

  void endGetter(newVal) {
    setState(() {
      end = newVal;
    });
    fetchEditNotifications(context);
  }

  @override
  void initState() {
    fetchEditNotifications(context);
    super.initState();
  }

  void fetchEditNotifications(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<EditNotificationProvider>(context, listen: false).geteditNotifications(12, start != null ? "${start!.year}-${start!.month}-${start!.day}" : "", end != null ? "${end!.year}-${end!.month}-${end!.day}" : "").then((_) {
        setState(() {
          isLoading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      int? statusCode = int.tryParse(e.toString().replaceAll('Exception:', '').trim());
      if (statusCode == 401) {
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.tryAutoLogin().then((_) {
            fetchEditNotifications(context);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      } else {
        AlertsDialog.doUreallyWant(
          context,
          "Echec",
          "échec de récupération des données",
          "Réessayer",
          true,
          fetchEditNotifications,
        );
      }
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<EditNotification> notifications = Provider.of<EditNotificationProvider>(context).editNotifications;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              MaterialPicker.muiDatePicker(context, startGetter, start);
            },
            child: Text(start != null ? "${start!.day}/${start!.month}/${start!.year}" : "Date début"),
          ),
          const Icon(
            Icons.arrow_forward,
            color: Colors.grey,
            size: 18,
          ),
          TextButton(
            onPressed: () {
              MaterialPicker.muiDatePicker(context, endGetter, end);
            },
            child: Text(end != null ? "${end!.day}/${end!.month}/${end!.year}" : "Date fin"),
          )
        ],
      ),
      body: isLoading
          ? const CupertinoAlertDialog(
              content: CupertinoActivityIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                    children: notifications.map((notif) {
                  return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).primaryColorLight.withOpacity(0.4),
                      ),
                      margin: const EdgeInsets.only(bottom: 6),
                      child: NotificationListItem(notif: notif));
                }).toList()),
              ),
            ),
    );
  }
}
