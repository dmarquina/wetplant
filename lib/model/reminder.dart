import 'package:wetplant/util/reminder_type.dart';

class Reminder {
  ReminderType reminderType;
  DateTime pickedDate;
  int frequencyDays;
  int postponedDays;
  int daysRemainingForAction;

  Reminder(
      {this.reminderType,
      this.pickedDate,
      this.frequencyDays,
      this.postponedDays,
      this.daysRemainingForAction});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
        reminderType: json['name'] == 'water' ? ReminderType.Water : ReminderType.Fertilize,
        pickedDate: DateTime.parse(json['lastDayAction']),
        frequencyDays: json['frequencyDays'],
        daysRemainingForAction: json['daysRemainingForAction']);
  }
}
