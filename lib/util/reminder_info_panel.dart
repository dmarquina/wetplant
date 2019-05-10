import 'package:flutter/material.dart';
import 'package:wetplant/model/reminder.dart';
import 'package:wetplant/util/date_util.dart';
import 'package:wetplant/util/reminder_type.dart';

class ReminderInfoPanel extends StatelessWidget {
  final Reminder reminder;
  final double sidePadding;

  ReminderInfoPanel({this.reminder, this.sidePadding = 0});

  String _getLastName() {
    switch (reminder.reminderType) {
      case ReminderType.Water:
        return 'ÚLTIMO RIEGO';
      case ReminderType.Fertilize:
        return 'ÚLTIMA FERTILIZ.';
      default:
        return '';
    }
  }

  String _getNextName() {
    switch (reminder.reminderType) {
      case ReminderType.Water:
        return 'RIEGO';
      case ReminderType.Fertilize:
        return 'FERTILIZ.';
      default:
        return '';
    }
  }

  DateTime preSetTimeFrame(DateTime time) {
    return DateTime(time.year, time.month, time.day, 0, 0, 0);
  }

  String _getDayToWaterName() {
    DateTime today = preSetTimeFrame(DateTime.now());
    DateTime tomorrow = today.add(Duration(days: 1));
    DateTime nextTime = reminder.lastDateAction
        .add(Duration(days: reminder.frequencyDays + reminder.postponedDays));

    if (tomorrow.day == nextTime.day && tomorrow.month == nextTime.month) {
      return 'Mañana';
    }

    if (nextTime.day < today.day && today.month == nextTime.month) {
      return '¡Hoy!';
    }

    if (today.day == nextTime.day && today.month == today.month) {
      return '¡Hoy!';
    }

    return formatDate(nextTime);
  }

  String _getLastWaterTimeName() {
    DateTime today = preSetTimeFrame(DateTime.now());
    DateTime lastWateredTime = preSetTimeFrame(reminder.lastDateAction);
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (today.day == lastWateredTime.day && today.month == lastWateredTime.month) {
      return 'Hoy';
    }

    if (yesterday.day == lastWateredTime.day && yesterday.month == today.month) {
      return 'Ayer';
    }

    return formatDate(lastWateredTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(sidePadding, 20, sidePadding, 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(
            children: <Widget>[
              Container(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Text('${_getLastName()}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black38, fontSize: 12)),
                Container(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(_getLastWaterTimeName(), style: TextStyle(fontSize: 28)))
              ])),
              SizedBox(height: 25),
              Container(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Text('FRECUENCIA',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black38, fontSize: 12)),
                Container(
                    padding: EdgeInsets.only(top: 6),
                    child: Text('${reminder.frequencyDays.toString()} ${reminder.frequencyDays!=1?'días':'día'}', style: TextStyle(fontSize: 28)))
              ]))
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Text('SIGUIENTE ${_getNextName()}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black38, fontSize: 12)),
                Container(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(_getDayToWaterName(),
                        style: TextStyle(fontSize: 28, color: Colors.black)))
              ])),
              SizedBox(height: 25),
              Container(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Text('POSPUESTO',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black38, fontSize: 12)),
                Container(
                    padding: EdgeInsets.only(top: 6),
                    child: Text('${reminder.postponedDays.toString()} ${reminder.postponedDays!=1?'días':'día'}',
                        style: TextStyle(fontSize: 28, color: Colors.black)))
              ]))
            ],
          )
        ]));
  }
}
