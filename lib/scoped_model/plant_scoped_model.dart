import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/constants/constant_variables.dart';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/model/reminder.dart';

mixin PlantScopedModel on Model {
  List<GardenPlant> gardenPlants = new List();
  List<GardenPlant> todayPlants = new List();
  List<Reminder> plantDetailReminders = new List();
  bool fetchingPlants = false;

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

  getPlants(String userId) {
    fetchingPlants = true;
    notifyListeners();
    http.get("$HOST:8080/plants/users/$userId").then((res) {
      List<dynamic> jsonDecoded = jsonDecode(res.body);
      gardenPlants = jsonDecoded.map((json) => GardenPlant.fromJson(json)).toList();
      todayPlants = _getTodayPlant(gardenPlants);
      fetchingPlants = false;
      notifyListeners();
    });
  }

  Future<GardenPlant> getPlantById(int plantId) async {
    var res = await http.get('$HOST:8080/plants/$plantId');
    dynamic jsonDecoded = jsonDecode(res.body);
    GardenPlant plantDetail = new GardenPlant.fromJson(jsonDecoded);
    return plantDetail;
  }

  addPlant(Map<String, dynamic> jsonPlant, File imageFile) async {
    http.Response res = await http.post("$HOST:8080/plants/",
        body: jsonEncode(jsonPlant), headers: {'Content-Type': 'application/json'});
    await _addImage(jsonDecode(res.body)['id'].toString(), imageFile);
  }

  updatePlant(Map<String, dynamic> jsonPlant, String imageURL, File imageFile) async {
    http.Response res = await http.put("$HOST:8080/plants/",
        body: jsonEncode(jsonPlant), headers: {'Content-Type': 'application/json'});
    if (imageFile != null) {
      await _updateImage(jsonDecode(res.body)['id'].toString(), imageURL, imageFile);
    }
  }

  deletePlant(int id, String imageURL) async {
    await http.delete("$HOST:8080/plants/$id", headers: {'Content-Type': 'application/json'});
  }

  updateLastDateAction(int reminderId, String lastDateAction, String ownerId) async {
    await http.patch('$HOST:8080/reminders/$reminderId/lastdateaction',
        body: jsonEncode({'lastDateAction': lastDateAction}),
        headers: {'Content-Type': 'application/json'});
    this.getPlants(ownerId);
    notifyListeners();
  }

  updatePostponedDays(int reminderId, int postponedDays, String ownerId) async {
    await http.patch('$HOST:8080/reminders/$reminderId/postponeddays',
        body: jsonEncode({'postponedDays': postponedDays}),
        headers: {'Content-Type': 'application/json'});
    this.getPlants(ownerId);
    notifyListeners();
  }

  Future<http.StreamedResponse> _addImage(String id, File image) {
    var url = Uri.parse("$HOST:8080/plants/image");
    var request = new http.MultipartRequest("POST", url);
    request.headers['content-type'] = 'multipart/form-data';
    request.fields['id'] = id;
    request.files.add(new http.MultipartFile.fromBytes("image", image.readAsBytesSync(),
        contentType: MediaType.parse('multipart/form-data'), filename: 'image'));
    return request.send();
  }

  Future<http.StreamedResponse> _updateImage(String id, String imageURL, File image) {
    var url = Uri.parse("$HOST:8080/plants/updatedimage");
    var request = new http.MultipartRequest("POST", url);
    request.headers['content-type'] = 'multipart/form-data';
    request.fields['id'] = id;
    request.fields['imageURL'] = imageURL;
    request.files.add(new http.MultipartFile.fromBytes("image", image.readAsBytesSync(),
        contentType: MediaType.parse('multipart/form-data'), filename: 'image'));
    return request.send();
  }
}
