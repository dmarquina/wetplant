import 'package:flutter/material.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/scoped_model/main_model.dart';
import 'package:wetplant/util/reminder_type.dart';

import './action_button.dart';
import './all_button.dart';

class QuickActionBar extends StatefulWidget {
  final List<GardenPlant> gardenPlants;
  final Function onAction;
  final MainModel model;

  QuickActionBar({this.gardenPlants, this.onAction, this.model});

  @override
  QuickActionBarState createState() => QuickActionBarState();
}

class QuickActionBarState extends State<QuickActionBar> {
  void _onAllActionPress(DateTime newDateOfAction) {
    List<int> remindersToAttendIds = [];
    widget.gardenPlants.forEach((gardenPlant) {
      gardenPlant.reminders
          .where((reminder) => widget.model.predicateReminderToAttend(reminder))
          .forEach((reminder) => remindersToAttendIds.add(reminder.id));
    });
    widget.model.updateLastDateAction(
        remindersToAttendIds, newDateOfAction.toIso8601String(), widget.model.authenticatedUser.id);
    widget.onAction();
    Navigator.of(context).pop();
  }

  void _onAllPostponePress(int days) {
    List<int> remindersToPostponeIds = [];
    widget.gardenPlants.forEach((gardenPlant) {
      gardenPlant.reminders
          .where((reminder) => widget.model.predicateReminderToAttend(reminder))
          .forEach((reminder) => remindersToPostponeIds.add(reminder.id));
    });
    widget.model
        .updatePostponedDays(remindersToPostponeIds, days, widget.model.authenticatedUser.id);
    widget.onAction();
    Navigator.of(context).pop();
  }

  void _onActionPress(ReminderType type, List<GardenPlant> gardenPlants, DateTime newDateOfAction) {
    List<int> remindersToAttendIds = [];
    gardenPlants.forEach((gardenPlant) {
      gardenPlant.reminders
          .where((reminder) =>
              widget.model.predicateReminderToAttend(reminder) && reminder.reminderType == type)
          .forEach((reminder) => remindersToAttendIds.add(reminder.id));
    });
    widget.model.updateLastDateAction(
        remindersToAttendIds, newDateOfAction.toIso8601String(), widget.model.authenticatedUser.id);
    widget.onAction();
    Navigator.of(context).pop();
  }

  void _onPostponePress(ReminderType type, List<GardenPlant> gardenPlants, int days) {
    List<int> remindersToPostponeIds = [];
    gardenPlants.forEach((gardenPlant) {
      gardenPlant.reminders
          .where((reminder) =>
              widget.model.predicateReminderToAttend(reminder) && reminder.reminderType == type)
          .forEach((reminder) => remindersToPostponeIds.add(reminder.id));
    });
    widget.model
        .updatePostponedDays(remindersToPostponeIds, days, widget.model.authenticatedUser.id);
    widget.onAction();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Map<ReminderType, List<int>> _availableReminders = {
      ReminderType.Water: [],
      ReminderType.Fertilize: []
    };

    widget.gardenPlants.forEach((gardenPlant) {
      gardenPlant.reminders
          .where((reminder) => widget.model.predicateReminderToAttend(reminder))
          .forEach((reminder) {
        _availableReminders[reminder.reminderType].add(gardenPlant.plant.id);
      });
    });

    List<Widget> buttons = [];
    _availableReminders.forEach((key, value) {
      buttons.add(ActionButton(
        type: key,
        amount: value.length,
        keys: value,
        gardenPlants: widget.gardenPlants,
        onActionPress: _onActionPress,
        onPostponePress: _onPostponePress,
      ));
    });
    buttons.add(AllButton(
      amount: widget.gardenPlants.length,
      onActionPress: _onAllActionPress,
      onPostponePress: _onAllPostponePress,
    ));

    return Container(
        height: 54,
        child: CustomScrollColor(
            axisDirection: AxisDirection.right,
            child: ListView(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                children: buttons)));
  }
}
