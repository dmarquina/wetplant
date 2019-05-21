import 'package:flutter/material.dart';
import 'package:wetplant/components/action_modal.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/model/reminder.dart';
import 'package:wetplant/scoped_model/main_model.dart';
import 'package:wetplant/util/custom_icons_icons.dart';
import 'package:wetplant/util/handle_linear_color_action.dart';
import 'package:wetplant/util/plant_list_image.dart';
import 'package:wetplant/util/plant_name_box.dart';
import 'package:wetplant/util/reminder_type.dart';

class TodayPlantCard extends StatelessWidget {
  final GardenPlant gardenPlant;
  final MainModel model;
  final bool isSelected;
  final Function(GardenPlant gardenPlant) onPress;
  final Function(GardenPlant gardenPlant) onLongPress;
  BuildContext _context;

  TodayPlantCard(this.gardenPlant, this.model, this.isSelected,
      {@required this.onPress, @required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    _context = context;
    return GestureDetector(
        onTap: () {
          onPress(gardenPlant);
        },
        onLongPress: () {
          onLongPress(gardenPlant);
        },
        child: Stack(children: <Widget>[
          _buildTodayCard(),
          isSelected ? _getSelectedOverlay() : Container()
        ]));
  }

  Widget _getSelectedOverlay() {
    return Positioned(
        child: Container(
      width: 180,
      height: 210,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(200),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Center(
        child: Icon(
          Icons.check,
          size: 64,
          color: Colors.white,
        ),
      ),
    ));
  }

  Widget _buildTodayCard() {
    return Container(
        child: Column(children: <Widget>[
      _buildPlantImageRemindersStack(),
      PlantNameBox(gardenPlant.plant.name,
          HandleLinearColorAction.getLinearColorsForAction(gardenPlant.reminders))
    ]));
  }

  Widget _buildPlantImageRemindersStack() {
    return Stack(children: <Widget>[
      PlantListImage(gardenPlant.plant.image, 170, 180),
      Positioned(left: 8, top: 8, child: _getReminderIcon())
    ]);
  }

  Widget _getReminderIcon() {
    return Container(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: gardenPlant.reminders
                .where((reminder) => model.predicateReminderToAttend(reminder))
                .map((reminder) {
              return GestureDetector(
                  onTap: () => _openActionDialog(reminder),
                  child: Container(
                      margin: EdgeInsets.only(right: 6),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[400], offset: Offset(0.0, 1.5), blurRadius: 1.5)
                          ]),
                      child: Center(child: _buildReminderTodayCardIcon(reminder.reminderType))));
            }).toList()));
  }

  Widget _buildReminderTodayCardIcon(ReminderType reminderType) {
    bool waterOrNot = reminderType == ReminderType.Water;
    return Icon(waterOrNot ? CustomIcons.water_amount_small : Icons.flash_on,
        color: waterOrNot ? BlueSecond : BrownMain, size: 25);
  }

  _openActionDialog(Reminder reminder) {
    showDialog(
        context: _context,
        builder: (_) => ActionModal(
            reminder,
            gardenPlant.plant,
            (daysToPostponed) => _postponedAction(reminder, daysToPostponed),
            (lastActionDate) => _onSubmitAction(reminder.id, lastActionDate)));
  }

  _postponedAction(Reminder reminder, int daysToPostponed) {
    int actualDaysToPostpone = reminder.postponedDays + daysToPostponed;
    model.updatePostponedDays([reminder.id], actualDaysToPostpone, model.authenticatedUser.id);
    Navigator.pop(_context);
  }

  _onSubmitAction(int reminderId, DateTime lastActionDate) {
    model.updateLastDateAction([reminderId], lastActionDate.toIso8601String(), model.authenticatedUser.id);
    Navigator.pop(_context);
  }
}
