import 'package:wetplant/model/plant.dart';
import 'package:wetplant/model/reminder.dart';

class GardenPlant {
  Plant plant;
  List<Reminder> reminders;

  GardenPlant({this.plant, this.reminders});

  factory GardenPlant.fromJson(Map<String, dynamic> json) {
    List<Reminder> re = new List();
    json['reminders'].forEach((reminderJson) => re.add(Reminder.fromJson(reminderJson)));
    re.sort((a, b) => a.reminderType.index.compareTo(b.reminderType.index));
    return GardenPlant(plant: Plant.fromJson(json), reminders: re);
  }
}
