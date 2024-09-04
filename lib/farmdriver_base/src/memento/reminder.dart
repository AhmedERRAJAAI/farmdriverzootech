import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 1)
class Reminder {
  Reminder({
    required this.title,
    required this.content,
    required this.date,
    required this.time,
    required this.id,
  });
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  DateTime time;

  @HiveField(4)
  int id;
}
