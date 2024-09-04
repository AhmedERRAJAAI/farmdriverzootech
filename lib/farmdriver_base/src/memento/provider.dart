import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'boxes.dart';
import 'reminder.dart';

class ReminderProvider with ChangeNotifier {
  List _reminders = [
    // FETCHED DATA ...
  ];

  List get reminders {
    return [
      ..._reminders
    ];
  }

// Add new reminder
  Future<void> saveToHive(title, content, date, time, id) async {
    await boxReminders.put(
      "key_$title$date",
      Reminder(
        title: title,
        content: content,
        date: date,
        time: time,
        id: id,
      ),
    );
    getReminders();
  }

//get all reminders as key-value pairs
  Future<void> getReminders() async {
    Map<dynamic, dynamic> remindersMap = boxReminders.toMap();
    _reminders = remindersMap.entries
        .map((e) => {
              'key': e.key,
              'value': e.value
            })
        .toList();
    // Sort the reminders by date in descending order (newer to older)
    _reminders.sort((a, b) {
      DateTime timeA = a['value'].time; // Replace 'date' with the actual field name in 'value'
      DateTime timeB = b['value'].time; // Replace 'date' with the actual field name in 'value'
      return timeB.compareTo(timeA); // Reversed order: dateB compared to dateA
    });
    _reminders.sort((a, b) {
      DateTime dateA = a['value'].date; // Replace 'date' with the actual field name in 'value'
      DateTime dateB = b['value'].date; // Replace 'date' with the actual field name in 'value'
      return dateB.compareTo(dateA); // Reversed order: dateB compared to dateA
    });

    notifyListeners();
  }

  Future<void> getRemindersByDate(DateTime? date) async {
    if (date == null) {
      return;
    }
    Map<dynamic, dynamic> remindersMap = boxReminders.toMap();
    _reminders = remindersMap.entries
        .where((e) {
          DateTime reminderDate = e.value.date; // Replace 'date' with the actual field name in 'value'
          return reminderDate.year == date.year && reminderDate.month == date.month && reminderDate.day == date.day;
        })
        .map((e) => {
              'key': e.key,
              'value': e.value,
            })
        .toList();

    // Sort the reminders by time in ascending order (earliest to latest)
    _reminders.sort((a, b) {
      DateTime timeA = a['value'].time; // Replace 'time' with the actual field name in 'value'
      DateTime timeB = b['value'].time; // Replace 'time' with the actual field name in 'value'
      return timeA.compareTo(timeB); // Ascending order: timeA compared to timeB
    });

    notifyListeners();
  }

// delete a reminder by key
  Future<void> deleteReminder(key) async {
    await boxReminders.delete(key).then((_) {
      getReminders();
    });
  }

// clear reminders
  Future<void> clearRemindersList() async {
    await boxReminders.clear();
    getReminders();
  }
}
