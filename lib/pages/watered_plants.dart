import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetplant/model/plant.dart';
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
        title: Text('Mis plantas'),
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
          return snapshot.hasData
              ? RefreshIndicator(
                  onRefresh: _getWateredPlants,
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: wateredPlantList.length,
                      itemBuilder: (context, index) {
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
                                  Container(
                                    height: 75,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'https://scontent.flim16-1.fna.fbcdn.net/v/t1.15752-9/55939931_688362904933544_2889652935891877888_n.jpg?_nc_cat=103&_nc_ht=scontent.flim16-1.fna&oh=c38863267a673446fc654276a2245e33&oe=5D374075'))),
                                  ),
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () => goToEditWateredPlant(plantId),
                                      child: Container(
                                      margin: EdgeInsets.only(top: 20.0),
                                      child: Column(children: <Widget>[
                                        Text(wateredPlantList.elementAt(index).plant.name,
                                            style: TextStyle(fontSize: 16.0),
                                            textAlign: TextAlign.center)
                                      ]),
                                    ),
                                    ),
                                  ),
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
                                            ],
                                          ),
                                          shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(0.0)),
                                          onPressed: minDays - actualDays <= 0
                                              ? () => _selectDate(context, plantId, actualDays)
                                              : null,
                                          color: HandleWateredDays.getColorsFromLastDaysWatering(
                                              minDays, maxDays, actualDays),
                                        )),
                                  )
                                ]));
                      }),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List> _getWateredPlants() async {
    var res = await http.get("http://192.168.1.40:8080/wateredplant/");
    List<dynamic> decodeJson = jsonDecode(res.body);
    return decodeJson.map((json) {
      Plant plant = new Plant(json['plant']['id'], json['plant']['name'], json['plant']['image']);
      WateredPlant wp = new WateredPlant(
          json['id'],
          json['minWateringDays'],
          json['maxWateringDays'],
          json['daysSinceLastDayWatering'],
          json['lastDayWatering'],
          plant);
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

    if (picked != null && picked != today) {
      waterPlant(plantId, picked.toIso8601String());
      setState(() {
        _getWateredPlants();
      });
    }
  }

  waterPlant(int plantId, String newLastDayWatering) async =>
      await http.patch('http://192.168.1.40:8080/wateredplant/$plantId',
          body: jsonEncode({'lastDayWatering': newLastDayWatering}),
          headers: {'Content-Type': 'application/json'});

  goToEditWateredPlant(int plantId) async {
    var wateredPlant = await _getWateredPlant(plantId);
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return EditWateredPlant(wateredPlant: wateredPlant);
    }));
  }

  Future<WateredPlant> _getWateredPlant(int plantId) async {
    var res = await http.get('http://192.168.1.40:8080/wateredplant/$plantId');
    dynamic wateredPlant = jsonDecode(res.body);
    Plant plant = new Plant(
        wateredPlant['plant']['id'], wateredPlant['plant']['name'], wateredPlant['plant']['image']);

    WateredPlant wateredPlantDetail = new WateredPlant(
        wateredPlant['id'],
        wateredPlant['minWateringDays'],
        wateredPlant['maxWateringDays'],
        wateredPlant['daysSinceLastDayWatering'],
        wateredPlant['lastDayWatering'],
        plant);
    return wateredPlantDetail;
  }
}
