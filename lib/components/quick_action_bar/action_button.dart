import 'package:flutter/material.dart';
import 'package:wetplant/components/multiple_action_dialog.dart';
import 'package:wetplant/constants/available-reminders.dart';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/util/reminder_type.dart';

class ActionButton extends StatelessWidget {
  final int amount;
  final ReminderType type;
  final List<int> keys;
  final List<GardenPlant> gardenPlants;
  final Function(ReminderType, List<GardenPlant>,DateTime) onActionPress;
  final Function(ReminderType, List<GardenPlant>, int) onPostponePress;

  ActionButton({
    this.amount,
    this.type,
    this.keys,
    this.gardenPlants,
    this.onActionPress,
    this.onPostponePress,
  });

  void _onTap(BuildContext context, AvailableReminder availableReminder) {
    List<GardenPlant> gardenPlantWithSelectedReminder =
        gardenPlants.where((gardenPlant) => keys.contains(gardenPlant.plant.id)).toList();

    showDialog(
        context: context,
        builder: (_) => MultipleActionDialog(
            amount: gardenPlantWithSelectedReminder.length,
            title: '${availableReminder.action} varios',
            action: '${availableReminder.action}',
            gradientColor: availableReminder.gradientColor,
            accentColor: availableReminder.accentColor,
            onActionPress: (datePicked) {
              onActionPress(type, gardenPlantWithSelectedReminder,datePicked);
            },
            onPostponePress: (int days) {
              onPostponePress(type, gardenPlantWithSelectedReminder, days);
            }));
  }

  @override
  Widget build(BuildContext context) {
    if (amount < 2) {
      return Container();
    }

    AvailableReminder availableReminder =
        availableReminders.firstWhere((a) => a.reminderType == type);

    Color color = availableReminder.primaryColor;
    Color _kKeyUmbraOpacity = color.withAlpha(51);
    Color _kKeyPenumbraOpacity = color.withAlpha(36);
    Color _kAmbientShadowOpacity = color.withAlpha(31);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0.0, 2.0),
              blurRadius: 4.0,
              spreadRadius: -1.0,
              color: _kKeyUmbraOpacity),
          BoxShadow(
              offset: Offset(0.0, 4.0),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              color: _kKeyPenumbraOpacity),
          BoxShadow(
              offset: Offset(0.0, 1.0),
              blurRadius: 10.0,
              spreadRadius: 0.0,
              color: _kAmbientShadowOpacity),
        ],
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      margin: EdgeInsets.only(left: 16),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              onTap: () {
                _onTap(context, availableReminder);
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: <Widget>[
                      Icon(availableReminder.iconData, color: availableReminder.primaryColor),
                      Text('Solo ${availableReminder.action}'),
                      Text(' ($amount)')
                    ],
                  )))),
    );
  }
}
