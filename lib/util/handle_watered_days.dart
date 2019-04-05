import 'dart:ui';

import 'package:flutter/material.dart';

class HandleWateredDays {
  static Color getColorsFromLastDaysWatering(int minDays, int maxDays, int actualDays) {
    Color color = Colors.grey;
    if (minDays <= actualDays && actualDays <= maxDays) {
      color = Colors.green;
    }
    if (maxDays < actualDays && actualDays <= maxDays + 7) {
      color = Colors.amber;
    }
    if (maxDays + 7 < actualDays) {
      color = Colors.redAccent;
    }
    return color;
  }
}
