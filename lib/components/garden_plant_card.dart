import 'package:flutter/material.dart';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/model/reminder.dart';
import 'package:wetplant/pages/plant_detail.dart';
import 'package:wetplant/util/plant_list_image.dart';
import 'package:wetplant/util/plant_name_box.dart';
import 'package:wetplant/util/reminder_info_widgets.dart';

class GardenPlantCard extends StatelessWidget {
  final GardenPlant gardenPlant;

  GardenPlantCard(this.gardenPlant);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PlantDetailPage(gardenPlant)));
          },
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              decoration: _declareGardenPlantCardDecoration(),
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  PlantListImage(gardenPlant.plant.image, 120, 120),
                  _buildPlantInfo()
                ]),
                PlantNameBox(gardenPlant.plant.name, 16)
              ])));
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
      child: Container(
        padding: EdgeInsets.only(right: 10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  gardenPlant.reminders.map((reminder) => _buildReminderInfo(reminder)).toList()),
        ),
      ),
    );
  }

  Widget _buildReminderInfo(Reminder reminder) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: _buildInfo(reminder));
  }

  List<Widget> _buildInfo(Reminder reminder) {
    List<Widget> children = [];
    children.add(buildReminderIcon(reminder.reminderType));
    children.add(buildIconInfo('Tiempo desde la última vez', Icons.access_time));
    children
        .add(buildTextInfo('Tiempo desde la última vez', reminder.daysWithoutAction.toString()));
    children.add(SizedBox(width: 20.0));
    children.add(buildIconInfo('Frecuencia aprox.', Icons.autorenew));
    children.add(buildTextInfo('Frecuencia aprox.', reminder.frequencyDays.toString()));
    if (reminder.postponedDays > 0) {
      children.add(buildIconInfo('Días pospuestos', Icons.add));
      children.add(buildTextInfo('Días pospuestos', reminder.postponedDays.toString()));
    }
    return children;
  }
}
