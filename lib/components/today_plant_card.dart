import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/components/action_modal.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/model/reminder.dart';
import 'package:wetplant/pages/plant_detail.dart';
import 'package:wetplant/scoped_model/main_model.dart';
import 'package:wetplant/util/custom_icons_icons.dart';
import 'package:wetplant/util/handle_linear_color_action.dart';
import 'package:wetplant/util/plant_list_image.dart';
import 'package:wetplant/util/plant_name_box.dart';
import 'package:wetplant/util/reminder_type.dart';

class TodayPlantCard extends StatelessWidget {
  final GardenPlant gardenPlant;
  MainModel _model;
  BuildContext _context;

  TodayPlantCard(this.gardenPlant);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      _model = model;
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PlantDetailPage(gardenPlant)));
        },
        child: Container(
            child: Column(children: <Widget>[
          _buildPlantImageRemindersStack(),
          PlantNameBox(gardenPlant.plant.name,
              HandleLinearColorAction.getLinearColorsForAction(gardenPlant.reminders))
        ])),
      );
    });
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
                .where((reminder) => _model.predicateReminderToAttend(reminder))
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
    _model.updatePostponedDays(reminder.id, actualDaysToPostpone, _model.ownerId);
    Navigator.pop(_context);
  }

  _onSubmitAction(int reminderId, DateTime lastActionDate) {
    _model.updateLastDateAction(reminderId, lastActionDate.toIso8601String(), _model.ownerId);
    Navigator.pop(_context);
  }
}
