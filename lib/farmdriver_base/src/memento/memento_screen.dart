import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../widgets/pickers.dart';
import '../../widgets/info_dialog.dart';

import 'provider.dart';
import 'widgets/reminders_planifier.dart';

class MementoScreen extends StatefulWidget {
  const MementoScreen({super.key});

  @override
  State<MementoScreen> createState() => _MementoScreenState();
}

class _MementoScreenState extends State<MementoScreen> {
  DateTime? filterDate;
  @override
  void initState() {
    fetchReminders();
    super.initState();
  }

  void getDate(DateTime? date) {
    if (date != null) {
      setState(() {
        filterDate = date;
      });
    }
    fetchRemindersByDate();
  }

  Future<void> fetchRemindersByDate() async {
    await Future.delayed(Duration.zero, () async {
      await Provider.of<ReminderProvider>(context, listen: false).getRemindersByDate(filterDate);
    });
  }

  Future<void> fetchReminders() async {
    await Future.delayed(Duration.zero, () async {
      await Provider.of<ReminderProvider>(context, listen: false).getReminders();
    });
  }

  Future<void> deleteReminder(String key) async {
    await Provider.of<ReminderProvider>(context, listen: false).deleteReminder(key);
  }

  Future<void> clearReminders() async {
    await Provider.of<ReminderProvider>(context, listen: false).clearRemindersList();
  }

  void cancelNotification(int notificationId) {
    AwesomeNotifications().cancel(notificationId);
  }

  @override
  Widget build(BuildContext context) {
    List reminders = Provider.of<ReminderProvider>(context, listen: true).reminders;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Memento",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              MaterialPicker.muiDatePicker(context, getDate, filterDate);
            },
            child: filterDate == null ? const Icon(Icons.calendar_month) : Text(DateFormat("dd/MM/yyyy").format(filterDate!)),
          ),
          if (filterDate != null)
            IconButton(
                onPressed: () {
                  setState(() {
                    filterDate = null;
                    fetchReminders();
                  });
                },
                icon: const Icon(Icons.clear))
        ],
        centerTitle: true,
      ),
      body: reminders.isEmpty
          ? Center(
              child: FittedBox(
                child: Column(
                  children: [
                    const Icon(
                      Icons.notifications_off,
                      color: Colors.grey,
                      size: 50,
                    ),
                    Text(
                      "Pas de rappels ${filterDate != null ? 'à cette date ${DateFormat('dd/MM/yyyy').format(filterDate!)}' : ''}",
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                // bool isOld = DateTime.now().isBefore(reminders[index]["value"].date) || (DateTime.now().isBefore(reminders[index]["value"].time));
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  color: Theme.of(context).primaryColorLight.withOpacity(0.3),
                  child: ListTile(
                    onTap: () {
                      AlertsDialog.showReminderDetails(
                        context,
                        reminders[index]["value"].title,
                        reminders[index]["value"].content,
                      );
                    },
                    leading: ClipOval(
                      child: Container(
                        color: Colors.amber.shade400,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const ClipOval(
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        deleteReminder(reminders[index]["key"]);
                        cancelNotification(reminders[index]["value"].id);
                      },
                    ),
                    title: Text(reminders[index]["value"].title),
                    subtitle: Text(
                      "${DateFormat('dd/MM/yyyy').format(reminders[index]["value"].date)} - ${DateFormat('HH:mm').format(reminders[index]["value"].time)}",
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              curve: Curves.bounceIn,
              child: const RemindersPlanifier(),
            ),
          );
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
