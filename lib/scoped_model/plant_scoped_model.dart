import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/constants/constant_variables.dart';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/model/plant.dart';
import 'package:wetplant/model/reminder.dart';

mixin PlantScopedModel on Model {
  List<GardenPlant> gardenPlants = new List();
  List<GardenPlant> todayPlants = new List();

  List<GardenPlant> _getTodayPlant(List<GardenPlant> gardenPlants) {
    return gardenPlants.where((gp) => checkIfReminderToAttend(gp) != null).toList() ?? [];
  }

  Reminder checkIfReminderToAttend(GardenPlant gp) {
    return gp.reminders
        .firstWhere((reminder) => predicateReminderToAttend(reminder), orElse: () => null);
  }

  bool predicateReminderToAttend(Reminder reminder) {
    return reminder.daysRemainingForAction <= 0;
  }

  Future<List> getPlants(String userId) async {
    var res = await http.get("$HOST:8080/plants/users/$userId");
    List<dynamic> decodeJson = jsonDecode(res.body);
    gardenPlants = decodeJson.map((json) => GardenPlant.fromJson(json)).toList();
    todayPlants = _getTodayPlant(gardenPlants);
    return gardenPlants;
  }

  Future<Plant> getPlantById(int plantId) async {
    var res = await http.get('$HOST:8080/plants/$plantId');
    dynamic plant = jsonDecode(res.body);
    Plant plantDetail = new Plant.fromJson(plant);
    return plantDetail;
  }

  addNewPlant(Map<String, dynamic> jsonPlant, File imageFile) async {
    http.Response res = await http.post("$HOST:8080/plants/",
        body: jsonEncode(jsonPlant), headers: {'Content-Type': 'application/json'});
    await _addImage(jsonDecode(res.body)['id'].toString(), imageFile);
  }

  updateLastDateAction(int reminderId, String lastDateAction) async {
    await http.patch('$HOST:8080/reminders/$reminderId/lastdateaction',
        body: jsonEncode({'lastDateAction': lastDateAction}),
        headers: {'Content-Type': 'application/json'});
    notifyListeners();
  }

  updatePostponedDays(int reminderId, int postponedDays) async {
    await http.patch('$HOST:8080/reminders/$reminderId/postponeddays',
        body: jsonEncode({'postponedDays': postponedDays}),
        headers: {'Content-Type': 'application/json'});
    notifyListeners();
  }

//
//  _updateWateredPlant() async {
//    if (!_formKey.currentState.validate()) {
//      return;
//    }
//    if (_dateTextToSave.isEmpty) {
//      _validate = true;
//    }
//    setState(() {
//      _waitingAction = true;
//    });
//    Map<String, dynamic> jsonPlant = {
//      'id': widget.plant.id.toString(),
//      'userId': widget.userId,
//      'lastDayWatering': _dateTextToSave,
//      'minWateringDays': _minDaysTextController.text,
//      'maxWateringDays': _maxDaysTextController.text,
//      'name': _nameTextController.text,
//      'image': _imagePlant
//    };
//    http.Response res = await http.put("$HOST:8080/plant/",
//        body: jsonEncode(jsonPlant), headers: {'Content-Type': 'application/json'});
//    if (imageFile != null) {
//      await _addImage(jsonDecode(res.body)['id'].toString(), imageFile);
//    }
//  }
//
  Future<http.StreamedResponse> _addImage(String id, File image) {
    var url = Uri.parse("$HOST:8080/plants/image");
    var request = new http.MultipartRequest("POST", url);
    request.headers['content-type'] = 'multipart/form-data';
    request.fields['id'] = id;
    request.files.add(new http.MultipartFile.fromBytes("image", image.readAsBytesSync(),
        contentType: MediaType.parse('multipart/form-data'), filename: 'image'));
    return request.send();
  }
}
