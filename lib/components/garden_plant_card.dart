import 'package:flutter/material.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/plant.dart';
import 'package:wetplant/model/reminder.dart';
import 'package:wetplant/util/custom_icons_icons.dart';
import 'package:wetplant/util/decoration.dart';
import 'package:wetplant/util/plant_list_image.dart';
import 'package:wetplant/util/reminder_type.dart';

class GardenPlantCard extends StatelessWidget {
  final Plant plant;
  final List<Reminder> reminders;

  GardenPlantCard(this.plant, this.reminders);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: _declareGardenPlantCardDecoration(),
        child: Column(children: <Widget>[
          Row(children: <Widget>[PlantListImage(plant.image), _buildPlantInfo()]),
          PlantNameBox(plant.name)
        ]));
  }

  BoxDecoration _declareGardenPlantCardDecoration() {
    return BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [
      BoxShadow(
        color: Colors.grey[400],
        offset: Offset(0.0, 1.5),
        blurRadius: 1.5,
      ),
    ]);
  }

  Widget _buildPlantInfo() {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(right: 10.0),
        scrollDirection: Axis.horizontal,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reminders.map((reminder) => _buildReminderInfo(reminder)).toList()),
      ),
    );
  }

  Widget _buildReminderInfo(Reminder reminder) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: _buildInfo(reminder));
  }

  List<Widget> _buildInfo(Reminder reminder) {
    List<Widget> children = [];
    children.add(_buildReminderIcon(reminder.reminderType));
    children.add(_buildIconInfo('Tiempo desde la última vez', Icons.access_time));
    children
        .add(_buildTextInfo('Tiempo desde la última vez', reminder.daysWithoutAction.toString()));
    if (reminder.postponedDays > 0) {
      children.add(_buildIconInfo('Días pospuestos', Icons.add));
      children.add(_buildTextInfo('Días pospuestos', reminder.postponedDays.toString()));
    }
    children.add(SizedBox(width: 20.0));
    children.add(_buildIconInfo('Frecuencia', Icons.autorenew));
    children.add(_buildTextInfo('Frecuencia', reminder.frequencyDays.toString()));
    children.add(SizedBox(width: 20.0));
    return children;
  }

  Widget _buildIconInfo(String tooltipMessage, IconData iconData) {
    return Tooltip(
        message: tooltipMessage, preferBelow: false, child: Icon(iconData, size:16,color: Colors.black54));
  }

  Widget _buildTextInfo(String tooltipMessage, String infoText) {
    return Tooltip(
        message: tooltipMessage,
        preferBelow: false,
        child: Text('$infoText d', style: TextStyle(color: Colors.black54)));
  }

  Widget _buildReminderIcon(ReminderType reminderType) {
    if (reminderType == ReminderType.Water) {
      return Icon(CustomIcons.water_amount_small, color: ReminderBlueMain, size: 45);
    } else {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Icon(Icons.flash_on, color: BrownMain, size: 25));
    }
  }
}
