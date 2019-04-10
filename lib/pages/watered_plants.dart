import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetplant/model/watered_plant.dart';
import 'package:wetplant/pages/edit_watered_plant.dart';
import 'package:wetplant/util/handle_watered_days.dart';

class WetPlantsPage extends StatefulWidget {
  @override
  WetPlantsPageState createState() => WetPlantsPageState();
}

class WetPlantsPageState extends State<WetPlantsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis plantitas'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                _goToNewWateredPlant(context);
              })
        ],
      ),
      body: FutureBuilder<List>(
        future: _getWateredPlants(),
        builder: (context, snapshot) {
          final wateredPlantList = snapshot.data;
          return snapshot.connectionState == ConnectionState.done
              ? ListView.builder(
                  padding: EdgeInsets.only(top: 5.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: wateredPlantList.length,
                  itemBuilder: (context, index) {
                    String plantName = wateredPlantList.elementAt(index).name;
                    String plantImage = wateredPlantList.elementAt(index).image;
                    int plantId = wateredPlantList.elementAt(index).id;
                    int minDays = wateredPlantList.elementAt(index).minWateringDays;
                    int maxDays = wateredPlantList.elementAt(index).maxWateringDays;
                    int actualDays = wateredPlantList.elementAt(index).daysSinceLastDayWatering;
                    return Card(
                        elevation: 3.0,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.network(plantImage != null ? plantImage : '',
                                  height: 75,
                                  width: 75,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center),
                              Flexible(
                                  child: GestureDetector(
                                      onTap: () => goToEditWateredPlant(plantId),
                                      child: Container(
                                          margin: EdgeInsets.only(top: 5.0),
                                          child: Column(children: <Widget>[
                                            Text(plantName,
                                                style: TextStyle(fontSize: 16.0),
                                                textAlign: TextAlign.center)
                                          ])))),
                              Flexible(
                                  child: Container(
                                      height: 75,
                                      width: 100,
                                      alignment: Alignment.centerRight,
                                      child: RaisedButton(
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text('Sin regar',
                                                    style: TextStyle(color: Colors.white)),
                                                Text(actualDays.toString(),
                                                    style: TextStyle(
                                                        fontSize: 16.0, color: Colors.white)),
                                                Text(actualDays == 1 ? 'día' : 'días',
                                                    style: TextStyle(color: Colors.white))
                                              ]),
                                          shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(0.0)),
                                          onPressed: minDays - actualDays <= 0
                                              ? () => _selectDate(context, plantId, actualDays)
                                              : null,
                                          color: HandleWateredDays.getColorsFromLastDaysWatering(
                                              minDays, maxDays, actualDays))))
                            ]));
                  })
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List> _getWateredPlants() async {
    var res = await http.get("http://192.168.1.45:8080/wateredplant/");
    List<dynamic> decodeJson = jsonDecode(res.body);
    return decodeJson.map((json) {
      WateredPlant wp = new WateredPlant(
          json['id'],
          json['minWateringDays'],
          json['maxWateringDays'],
          json['daysSinceLastDayWatering'],
          json['lastDayWatering'],
          json['name'],
          json['image']);
      return wp;
    }).toList();
  }

  _goToNewWateredPlant(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditWateredPlant()));
  }

  DateTime today = DateTime.now();

  Future<Null> _selectDate(BuildContext context, int plantId, int daysSinceLastWatered) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: today.subtract(Duration(days: daysSinceLastWatered)),
        lastDate: today);

    if (picked != null) {
      waterPlant(plantId, picked.toIso8601String());
      setState(() {
        _getWateredPlants();
      });
    }
  }

  waterPlant(int plantId, String newLastDayWatering) async =>
      await http.patch('http://192.168.1.45:8080/wateredplant/$plantId',
          body: jsonEncode({'lastDayWatering': newLastDayWatering}),
          headers: {'Content-Type': 'application/json'});

  goToEditWateredPlant(int plantId) async {
    var wateredPlant = await _getWateredPlant(plantId);
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return EditWateredPlant(wateredPlant: wateredPlant);
    }));
  }

  Future<WateredPlant> _getWateredPlant(int plantId) async {
    var res = await http.get('http://192.168.1.45:8080/wateredplant/$plantId');
    dynamic wateredPlant = jsonDecode(res.body);

    WateredPlant wateredPlantDetail = new WateredPlant(
        wateredPlant['id'],
        wateredPlant['minWateringDays'],
        wateredPlant['maxWateringDays'],
        wateredPlant['daysSinceLastDayWatering'],
        wateredPlant['lastDayWatering'],
        wateredPlant['name'],
        wateredPlant['image']);
    return wateredPlantDetail;
  }
}
