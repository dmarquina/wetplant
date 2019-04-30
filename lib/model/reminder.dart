import 'package:wetplant/util/reminder_type.dart';

class Reminder {
  ReminderType _reminderType;
  DateTime _pickedDate;
  int _daysFrequency;

  Reminder(this._reminderType, this._pickedDate, this._daysFrequency);

  ReminderType get reminderType => _reminderType;

  setReminderType(ReminderType value) => _reminderType = value;

  DateTime get pickedDate => _pickedDate;

  setPickedDate(DateTime value) => _pickedDate = value;

  get daysFrequency => _daysFrequency;

  setDaysFrequency(int value) => _daysFrequency = value;

}
