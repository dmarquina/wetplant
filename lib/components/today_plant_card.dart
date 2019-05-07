import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/components/action_modal.dart';
import 'package:wetplant/constants/available-reminders.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/plant.dart';
import 'package:wetplant/model/reminder.dart';
import 'package:wetplant/scoped_model/main_model.dart';
import 'package:wetplant/util/custom_icons_icons.dart';
import 'package:wetplant/util/decoration.dart';
import 'package:wetplant/util/plant_list_image.dart';
import 'package:wetplant/util/reminder_type.dart';

class TodayPlantCard extends StatelessWidget {
  final Plant plant;
  final List<Reminder> reminders;
  MainModel _model;

  TodayPlantCard(this.plant, this.reminders);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      _model = model;
      return Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          decoration: _todayPlantCardDecoration(),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              PlantListImage(plant.image),
              _buildPlantRemindersAction(context)
            ]),
            PlantNameBox(plant.name)
          ]));
    });
  }

  BoxDecoration _todayPlantCardDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [BoxShadow(color: Colors.grey[400], offset: Offset(0.0, 1.5), blurRadius: 1.5)]);
  }

  Widget _buildPlantRemindersAction(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      padding: EdgeInsets.only(right: 10.0),
      scrollDirection: Axis.horizontal,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: reminders
              .where((reminder) => _model.predicateReminderToAttend(reminder))
              .map((reminder) => _buildReminderActionButton(context, reminder))
              .toList()),
    ));
  }

  Widget _buildReminderActionButton(BuildContext context, Reminder reminder) {
    bool waterOrNot = reminder.reminderType == ReminderType.Water;
    return Container(
        padding: EdgeInsets.only(left: 10.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
          FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              onPressed: () => _openActionDialog(context, reminder),
              color: waterOrNot ? BlueSecond : BrownMain,
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          waterOrNot ? 'REGAR' : 'FERTILIZAR',
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        )),
                    _buildReminderIcon(reminder.reminderType)
                  ])))
        ]));
  }

  _openActionDialog(BuildContext context, Reminder reminder) {
    showDialog(
        context: context,
        builder: (_) => ActionModal(
            reminder,
            plant,
            (daysToPostponed) => _postponedAction(reminder, daysToPostponed, context),
            (lastActionDate) => _onSubmitAction(reminder.id, lastActionDate, context)));
  }

  _postponedAction(Reminder reminder, int daysToPostponed, BuildContext context) {
    int actualDaysToPostpone = reminder.daysWithoutAction + daysToPostponed;
    _model.updatePostponedDays(reminder.id, actualDaysToPostpone);

    Navigator.pop(context);
  }

  _onSubmitAction(int reminderId, DateTime lastActionDate, BuildContext context) {
    _model.updateLastDateAction(reminderId, lastActionDate.toIso8601String());
    Navigator.pop(context);
  }

  Widget _buildReminderIcon(ReminderType reminderType) {
    if (reminderType == ReminderType.Water) {
      return Icon(CustomIcons.water_amount_small, color: Colors.white, size: 30);
    } else {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Icon(Icons.flash_on, color: Colors.white, size: 20));
    }
  }
}
