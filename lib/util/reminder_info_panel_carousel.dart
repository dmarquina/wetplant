import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wetplant/model/reminder.dart';
import 'package:wetplant/util/reminder_info_panel.dart';

class ReminderInfoPanelCarousel extends StatelessWidget {
  final List<Reminder> reminders;

  ReminderInfoPanelCarousel({this.reminders});

  Widget _getEmptyRemindersWidget() {
    return Container(
        alignment: Alignment(0, 0),
        child: Text('NO HAY RECORDATORIOS ACTIVOS :\'( ',
            style: TextStyle(fontSize: 16, color: Colors.black38)));
  }

  @override
  Widget build(BuildContext context) {
    if (reminders.length == 0) {
      return _getEmptyRemindersWidget();
    }

    if (reminders.length == 1) {
      return ReminderInfoPanel(reminder: reminders[0], sidePadding: 16);
    }

    return CarouselSlider(
        items: reminders.map((reminder) {
          return Builder(builder: (BuildContext context) {
            return ReminderInfoPanel(reminder: reminder);
          });
        }).toList(),
        autoPlay: true,
        viewportFraction: 1.0);
  }
}
