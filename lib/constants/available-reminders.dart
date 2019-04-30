import 'package:flutter/material.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/util/custom_icons_icons.dart';
import 'package:wetplant/util/reminder_type.dart';

class AvailableReminder {
  final String title;
  final IconData iconData;
  final Color primaryColor;
  final Color accentColor;
  final LinearGradient gradientColor;
  final double size;
  final int defaultFrequencyValue;
  final ReminderType reminderType;

  AvailableReminder(this.title, this.iconData, this.primaryColor, this.accentColor,
      this.gradientColor, this.size, this.defaultFrequencyValue, this.reminderType);
}

AvailableReminder availableWaterReminder = AvailableReminder(
    'Riego',
    CustomIcons.water_amount_small,
    ReminderBlueMain,
    ReminderBlueSecond,
    BlueGradient,
    40.0,
    7,
    ReminderType.Water);
AvailableReminder availableFertilizeReminder = AvailableReminder('Fertilizar', Icons.flash_on,
    BrownMain, BrownSecond, BrownGradient, 25.0, 30, ReminderType.Fertilize);

List<AvailableReminder> availableReminders = [
  availableWaterReminder,
  availableFertilizeReminder,
];
