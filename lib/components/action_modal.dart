import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wetplant/components/frequency_days.dart';
import 'package:wetplant/components/gradient_material_button.dart';
import 'package:wetplant/components/last_action_date.dart';
import 'package:wetplant/constants/available-reminders.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/plant.dart';
import 'package:wetplant/model/reminder.dart';
import 'package:wetplant/util/reminder_type.dart';

class ActionModal extends StatefulWidget {
  final Function(int) onPostpone;
  final Function(DateTime) onSubmitAction;
  final Reminder reminder;
  final Plant plant;

  ActionModal(this.reminder, this.plant, this.onPostpone, this.onSubmitAction);

  @override
  _ActionModalState createState() => _ActionModalState();
}

class _ActionModalState extends State<ActionModal> {
  DateTime datePicked;
  ReminderType rType;
  int daysToPostpone;
  AvailableReminder availableReminder;

  @override
  void initState() {
    _initValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(contentPadding: EdgeInsets.all(0), children: <Widget>[
      Container(width: MediaQuery.of(context).size.width),
      _buildAvatarPlantImage(),
      Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(widget.plant.name.toUpperCase(),
              style: TextStyle(color: Colors.black54, fontSize: 16))),
      Divider(),
      Center(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                LastActionDate(availableReminder.accentColor, datePicked, (date) {
                  _setDatePicked(date);
                }, lastTimeAction: widget.reminder.lastDateAction)
              ]))),
      FrequencyDays(
          type: 'Posponer',
          initialValue: daysToPostpone,
          color: YellowSecond,
          onChange: (value) {
            _setDaysToPostpone(value);
          }),
      Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              ButtonBar(children: <Widget>[_buildPostponeButton(), _buildActionButton()])
            ])),
      )
    ]);
  }

  Widget _buildActionButton() {
    return GradientButton(
        shadow: true,
        gradient: availableReminder.gradientColor,
        height: 40,
        width: 120,
        buttonRadius: BorderRadius.all(Radius.circular(8)),
        onPressed: () => widget.onSubmitAction(datePicked),
        child: Text(rType == ReminderType.Water ? 'REGAR' : 'FERTILIZAR',
            style: TextStyle(fontSize: 16, color: Colors.white)));
  }

  Widget _buildPostponeButton() {
    return GradientButton(
        shadow: true,
        gradient: YellowGradient,
        height: 40,
        width: 120,
        buttonRadius: BorderRadius.all(Radius.circular(8)),
        onPressed: () => widget.onPostpone(daysToPostpone),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('POSPONER', style: TextStyle(fontSize: 12, color: Colors.white)),
          Text('+ ${daysToPostpone.toString()} ${daysToPostpone == 1 ? 'día' : 'días'}',
              style: TextStyle(fontSize: 10, color: Colors.white))
        ]));
  }

  _setDaysToPostpone(int daysToPostpone) {
    setState(() {
      this.daysToPostpone = daysToPostpone;
    });
  }

  _setDatePicked(DateTime datePicked) {
    this.datePicked = datePicked;
  }

  Widget _buildAvatarPlantImage() {
    return Stack(children: <Widget>[
      Center(
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.plant.image??''), fit: BoxFit.cover)))),
      Positioned(
          right: 8,
          top: 8,
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close, size: 28, color: Colors.grey)))
    ]);
  }

  _initValues() {
    availableReminder = getAvailableReminderByType(widget.reminder.reminderType);
    daysToPostpone = 1;
    datePicked = DateTime.now();
    rType = availableReminder.reminderType;
  }
}
