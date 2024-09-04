import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider.dart';

class RemindersPlanifier extends StatefulWidget {
  final DateTime? initDate;
  const RemindersPlanifier({super.key, this.initDate});

  @override
  State<RemindersPlanifier> createState() => _RemindersPlanifierState();
}

class _RemindersPlanifierState extends State<RemindersPlanifier> {
  late DateTime date;
  final int id = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  DateTime time = DateTime.now();
  @override
  void initState() {
    date = widget.initDate ?? DateTime.now();
    super.initState();
  }

  Future<void> saveToHive(context) async {
    await Provider.of<ReminderProvider>(context, listen: false).saveToHive(
      titleController.text,
      contentController.text,
      date,
      time,
      id,
    );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        content: Text('Rappel enregistré'),
      ),
    );
  }

  void dateGetter(newDate) {
    setState(() {
      date = newDate;
    });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Enter date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Date"),
                    CupertinoButton(
                      onPressed: () => _showDialog(
                        CupertinoDatePicker(
                          initialDateTime: date,
                          mode: CupertinoDatePickerMode.date,
                          use24hFormat: true,
                          showDayOfWeek: false,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() => date = newDate);
                          },
                        ),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(date),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade500),
                // Enter hours
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Heure"),
                    CupertinoButton(
                      onPressed: () => _showDialog(
                        CupertinoDatePicker(
                          initialDateTime: time,
                          mode: CupertinoDatePickerMode.time,
                          use24hFormat: true,
                          showDayOfWeek: false,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => time = newTime);
                          },
                        ),
                      ),
                      child: Text(
                        DateFormat('HH:mm').format(time),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),

                TextFormField(
                  controller: titleController,
                  maxLength: 50,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    labelText: "Titre",
                    labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.amber,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val != null && val.isEmpty) {
                      return "field can't be empty";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 200,
                  child: TextFormField(
                    controller: contentController,
                    maxLines: 10,
                    minLines: null,
                    maxLength: 300,
                    // expands: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      labelText: "Description",
                      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.amber,
                    textInputAction: TextInputAction.newline,
                    validator: (val) {
                      if (val != null && val.isEmpty) {
                        return "field can't be empty";
                      }
                      return null;
                    },
                  ),
                ),
                // Planifier reminder
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () {
                      saveToHive(context);
                      AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: id,
                          channelKey: "reminder_channel_key",
                          title: titleController.text,
                          body: contentController.text,
                          // icon: 'assets/images/man.png',
                        ),
                        schedule: NotificationCalendar(
                          year: date.year,
                          month: date.month,
                          day: date.day,
                          hour: time.hour,
                          minute: time.minute,
                          second: 0,
                          millisecond: 0,
                          repeats: false,
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Planifier un rappel",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.notification_add,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
