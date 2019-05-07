import 'package:wetplant/util/reminder_type.dart';

class Reminder {
  int id;
  ReminderType reminderType;
  DateTime lastDateAction;
  int frequencyDays;
  int postponedDays;
  int daysRemainingForAction;
  int daysWithoutAction;

  Reminder(
      {this.id,
      this.reminderType,
      this.lastDateAction,
      this.frequencyDays,
      this.postponedDays,
      this.daysRemainingForAction,
      this.daysWithoutAction});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
        id: json['id'],
        reminderType: json['name'] == 'water' ? ReminderType.Water : ReminderType.Fertilize,
        lastDateAction: DateTime.parse(json['lastDateAction']),
        frequencyDays: json['frequencyDays'],
        postponedDays: json['postponedDays'],
        daysRemainingForAction: json['daysRemainingForAction'],
        daysWithoutAction: json['daysWithoutAction']);
  }
}
