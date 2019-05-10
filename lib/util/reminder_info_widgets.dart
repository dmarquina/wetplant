import 'package:flutter/material.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/util/custom_icons_icons.dart';
import 'package:wetplant/util/reminder_type.dart';

Widget buildReminderIcon(ReminderType reminderType) {
  if (reminderType == ReminderType.Water) {
    return Icon(CustomIcons.water_amount_small, color: ReminderBlueMain, size: 45);
  } else {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Icon(Icons.flash_on, color: BrownMain, size: 25));
  }
}

Widget buildIconInfo(String tooltipMessage, IconData iconData) {
  return Tooltip(
      message: tooltipMessage,
      preferBelow: false,
      child: Icon(iconData, size: 16, color: Colors.black54));
}

Widget buildTextInfo(String tooltipMessage, String infoText) {
  return Tooltip(
      message: tooltipMessage,
      preferBelow: false,
      child: Text('$infoText ${infoText == '1' ? 'día' : 'días'}',
          style: TextStyle(color: Colors.black54)));
}