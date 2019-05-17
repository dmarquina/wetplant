import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/reminder.dart';

class HandleLinearColorAction {
  static LinearGradient getLinearColorsForAction(List<Reminder> reminders) {
    LinearGradient color = GreenGradient;
    for (Reminder reminder in reminders) {
      var daysWithoutAction = reminder.daysWithoutAction;
      var normalAmountDays = reminder.frequencyDays + reminder.postponedDays;
      var criticalDays = (reminder.frequencyDays * 1.5) + reminder.postponedDays;

      if (daysWithoutAction > normalAmountDays && daysWithoutAction < criticalDays) {
        color = YellowGradient;
      }
      if (daysWithoutAction > criticalDays) {
        color = RedGradient;
        break;
      }
    }
    return color;
  }
}
