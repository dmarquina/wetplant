import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/dto/garden_plants';
import 'package:wetplant/model/plant.dart';

mixin PlantScopedModel on Model {
  Future<List> getMyPlants(String userId) async {
    var res = await http.get("http://192.168.1.40:8080/plant/user/$userId");
    List<dynamic> decodeJson = jsonDecode(res.body);
    return decodeJson.map((json) => GardenPlant.fromJson(json)).toList();
  }

  Future<Plant> getPlantById(int plantId) async {
    var res = await http.get('http://192.168.1.40:8080/plant/$plantId');
    dynamic plant = jsonDecode(res.body);

    Plant plantDetail = new Plant.fromJson(plant);
    return plantDetail;
  }

  waterPlant(int plantId, String newLastDayWatering) async =>
      await http.patch('http://192.168.1.40:8080/plant/$plantId',
          body: jsonEncode({'lastDayWatering': newLastDayWatering}),
          headers: {'Content-Type': 'application/json'});

  addNewPlant(Map<String, dynamic> jsonPlant, File imageFile) async {
    http.Response res = await http.post("http://192.168.1.40:8080/plant/",
        body: jsonEncode(jsonPlant), headers: {'Content-Type': 'application/json'});
    await _addImage(jsonDecode(res.body)['id'].toString(), imageFile);
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
//    http.Response res = await http.put("http://192.168.1.40:8080/plant/",
//        body: jsonEncode(jsonPlant), headers: {'Content-Type': 'application/json'});
//    if (imageFile != null) {
//      await _addImage(jsonDecode(res.body)['id'].toString(), imageFile);
//    }
//  }
//
  Future<http.StreamedResponse> _addImage(String id, File image) {
    var url = Uri.parse("http://192.168.1.40:8080/plant/image");
    var request = new http.MultipartRequest("POST", url);
    request.headers['content-type'] = 'multipart/form-data';
    request.fields['id'] = id;
    request.files.add(new http.MultipartFile.fromBytes("image", image.readAsBytesSync(),
        contentType: MediaType.parse('multipart/form-data'), filename: 'image'));
    return request.send();
  }
}
