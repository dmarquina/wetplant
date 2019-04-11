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
        backgroundColor: Colors.green,
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
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final wateredPlantList = snapshot.data;
          return snapshot.connectionState == ConnectionState.done
              ? RefreshIndicator(
                  onRefresh: _getWateredPlants,
                  child: ListView.builder(
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
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            height: 110,
                                            width: 100,
                                            alignment: Alignment.centerLeft,
                                            child: RaisedButton(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text('Sin regar',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600)),
                                                      Text(actualDays.toString(),
                                                          style: TextStyle(
                                                              fontSize: 32.0,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600)),
                                                      Text(actualDays == 1 ? 'día' : 'días',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600))
                                                    ]),
                                                onPressed: minDays - actualDays <= 0
                                                    ? () =>
                                                        _selectDate(context, plantId, actualDays)
                                                    : null,
                                                color:
                                                    HandleWateredDays.getColorsFromLastDaysWatering(
                                                        minDays, maxDays, actualDays))),
                                        Container(
                                            height: 100,
                                            width: MediaQuery.of(context).size.width / 2.5,
                                            alignment: Alignment.centerLeft,
                                            child: GestureDetector(
                                                onTap: () => goToEditWateredPlant(plantId),
                                                child: Container(
                                                    child: Text(
                                                  plantName,
                                                  style: TextStyle(
                                                      fontSize: 20.0),
                                                  textAlign: TextAlign.start,
                                                )))),
                                      ]),
                                  Image.network(plantImage != null ? plantImage : '',
                                      height: 110,
                                      width: 110,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center)
                                ]));
                      }))
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
    Navigator.pushReplacementNamed(context, '/edit');
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
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
