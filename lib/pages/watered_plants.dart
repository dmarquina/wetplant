import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/fab_bottom_app_bar.dart';
import 'package:wetplant/components/page_title.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/watered_plant.dart';
import 'package:wetplant/pages/edit_watered_plant.dart';
import 'package:wetplant/pages/login.dart';
import 'package:wetplant/util/custom_icons_icons.dart';
import 'package:wetplant/util/handle_watered_days.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WateredPlantsPage extends StatefulWidget {
  final String userId;

  WateredPlantsPage(this.userId);

  @override
  WateredPlantsPageState createState() => WateredPlantsPageState();
}

class WateredPlantsPageState extends State<WateredPlantsPage> {
  @override
  Widget build(BuildContext context) {
    Color timeBasedColor = BlueMain;
    Color _kKeyUmbraOpacity = timeBasedColor.withAlpha(51);
    Color _kKeyPenumbraOpacity = timeBasedColor.withAlpha(36);
    Color _kAmbientShadowOpacity = timeBasedColor.withAlpha(31);
    return Scaffold(
        body: CustomScrollColor(
            child: ListView(padding: EdgeInsets.all(20.0), children: <Widget>[
      PageTitle(title: 'Jardín'),
      Container(
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            offset: Offset(0.0, 1.5),
            blurRadius: 1.5,
          ),
        ]),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://s3.us-west-2.amazonaws.com/dmarquina-plants/8-23-04-2019-16-37-50'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5)))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Icon(CustomIcons.water_amount_small,
                              color: ReminderBlueMain, size: 60)),
                      Icon(Icons.autorenew),
                      Text('9 d'),
                      SizedBox(width: 20.0),
                      Icon(Icons.access_time),
                      Text('3 d')
                    ],
                  ),Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Icon(Icons.flash_on,
                              color: BrownMain, size: 40)),
                      Icon(Icons.autorenew),
                      Text('60 d'),
                      SizedBox(width: 20.0),
                      Icon(Icons.access_time),
                      Text('35 d')
                    ],
                  )
                ],
              )
            ],
          ),
          Container(
              height: 50,
              alignment: Alignment(-1.0, 0.0),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                gradient: GreenGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      offset: Offset(0.0, 2.0),
                      blurRadius: 4.0,
                      spreadRadius: -1.0,
                      color: _kKeyUmbraOpacity),
                  BoxShadow(
                      offset: Offset(0.0, 4.0),
                      blurRadius: 5.0,
                      spreadRadius: 0.0,
                      color: _kKeyPenumbraOpacity),
                  BoxShadow(
                      offset: Offset(0.0, 1.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                      color: _kAmbientShadowOpacity),
                ],
              ),
              child: Text('Nido de crias',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )))
        ]),
      ),Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            offset: Offset(0.0, 1.5),
            blurRadius: 1.5,
          ),
        ]),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://s3.us-west-2.amazonaws.com/dmarquina-plants/8-23-04-2019-16-37-50'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5)))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Icon(CustomIcons.water_amount_small,
                              color: ReminderBlueMain, size: 60)),
                      Icon(Icons.autorenew),
                      Text('9 d'),
                      SizedBox(width: 20.0),
                      Icon(Icons.access_time),
                      Text('3 d')
                    ],
                  ),Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Icon(Icons.flash_on,
                              color: BrownMain, size: 40)),
                      Icon(Icons.autorenew),
                      Text('60 d'),
                      SizedBox(width: 20.0),
                      Icon(Icons.access_time),
                      Text('35 d')
                    ],
                  )
                ],
              )
            ],
          ),
          Container(
              height: 50,
              alignment: Alignment(-1.0, 0.0),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                gradient: GreenGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      offset: Offset(0.0, 2.0),
                      blurRadius: 4.0,
                      spreadRadius: -1.0,
                      color: _kKeyUmbraOpacity),
                  BoxShadow(
                      offset: Offset(0.0, 4.0),
                      blurRadius: 5.0,
                      spreadRadius: 0.0,
                      color: _kKeyPenumbraOpacity),
                  BoxShadow(
                      offset: Offset(0.0, 1.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                      color: _kAmbientShadowOpacity),
                ],
              ),
              child: Text('Nido de crias',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )))
        ]),
      )
//          FutureBuilder<List>(
//            future: _getWateredPlants(),
//            builder: (BuildContext context, AsyncSnapshot snapshot) {
//              final List<WateredPlant> wateredPlantList = snapshot.data;
//              return snapshot.connectionState == ConnectionState.done
//                  ? wateredPlantList != null && wateredPlantList.length > 0
//                      ? RefreshIndicator(
//                          onRefresh: _getWateredPlants,
//                          child: ListView.builder(
//                              padding: EdgeInsets.only(top: 5.0),
//                              physics: const AlwaysScrollableScrollPhysics(),
//                              itemCount: wateredPlantList.length,
//                              itemBuilder: (context, index) {
//                                String plantName = wateredPlantList.elementAt(index).name;
//                                String plantImage = wateredPlantList.elementAt(index).image;
//                                int plantId = wateredPlantList.elementAt(index).id;
//                                int minDays = wateredPlantList.elementAt(index).minWateringDays;
//                                int maxDays = wateredPlantList.elementAt(index).maxWateringDays;
//                                int actualDays =
//                                    wateredPlantList.elementAt(index).daysSinceLastDayWatering;
//                                return Card(
//                                    elevation: 30.0,
//                                    child: Row(
//                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                        crossAxisAlignment: CrossAxisAlignment.start,
//                                        children: <Widget>[
//                                          Row(
//                                              mainAxisAlignment: MainAxisAlignment.start,
//                                              crossAxisAlignment: CrossAxisAlignment.start,
//                                              children: <Widget>[
//                                                Container(
//                                                    height: 110,
//                                                    width: 100,
//                                                    alignment: Alignment.centerLeft,
//                                                    child: RaisedButton(
//                                                        child: Column(
//                                                            mainAxisAlignment:
//                                                                MainAxisAlignment.spaceEvenly,
//                                                            crossAxisAlignment:
//                                                                CrossAxisAlignment.center,
//                                                            children: <Widget>[
//                                                              actualDays == 0
//                                                                  ? Column(children: <Widget>[
//                                                                      Text('REGADA',
//                                                                          style: TextStyle(
//                                                                              fontSize: 15.0,
//                                                                              color: Colors.white,
//                                                                              fontWeight:
//                                                                                  FontWeight.w600)),
//                                                                      SizedBox(height: 10.0),
//                                                                      Icon(Icons.tag_faces,
//                                                                          size: 35.0,
//                                                                          color: Colors.white),
//                                                                      SizedBox(height: 10.0),
//                                                                      Text('¡Gracias!',
//                                                                          style: TextStyle(
//                                                                              fontSize: 15.0,
//                                                                              color: Colors.white,
//                                                                              fontWeight:
//                                                                                  FontWeight.w600)),
//                                                                    ])
//                                                                  : Column(
//                                                                      children: <Widget>[
//                                                                        Text('Sin regar',
//                                                                            style: TextStyle(
//                                                                                fontSize: 15.0,
//                                                                                color: Colors.white,
//                                                                                fontWeight:
//                                                                                    FontWeight.w600)),
//                                                                        SizedBox(height: 8.0),
//                                                                        Text(actualDays.toString(),
//                                                                            style: TextStyle(
//                                                                                fontSize: 32.0,
//                                                                                color: Colors.white,
//                                                                                fontWeight:
//                                                                                    FontWeight.w600)),
//                                                                        SizedBox(height: 8.0),
//                                                                        Text(
//                                                                            actualDays == 1
//                                                                                ? 'día'
//                                                                                : 'días',
//                                                                            style: TextStyle(
//                                                                                fontSize: 15.0,
//                                                                                color: Colors.white,
//                                                                                fontWeight:
//                                                                                    FontWeight.w600)),
//                                                                      ],
//                                                                    )
//                                                            ]),
//                                                        onPressed: minDays - actualDays <= 0
//                                                            ? () => _selectDate(
//                                                                context, plantId, actualDays)
//                                                            : null,
//                                                        color: HandleWateredDays
//                                                            .getColorsFromLastDaysWatering(
//                                                                minDays, maxDays, actualDays))),
//                                                Container(
//                                                    height: 100,
//                                                    width: MediaQuery.of(context).size.width / 2.5,
//                                                    alignment: Alignment.centerLeft,
//                                                    child: GestureDetector(
//                                                        onTap: () => _goToEditWateredPlant(plantId),
//                                                        child: Container(
//                                                            child: Text(
//                                                          plantName,
//                                                          style: TextStyle(fontSize: 20.0),
//                                                          textAlign: TextAlign.start,
//                                                        )))),
//                                              ]),
//                                          Image.network(plantImage != null ? plantImage : '',
//                                              height: 110,
//                                              width: 110,
//                                              fit: BoxFit.cover,
//                                              alignment: Alignment.center)
//                                        ]));
//                              }))
//                      : Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text('Aún no tienes ninguna planta guardada',
//                                  style: TextStyle(color: Colors.white)),
//                              SizedBox(height: 10.0),
//                              Text('Agrega una', style: TextStyle(color: Colors.white)),
//                              SizedBox(height: 30.0),
//                              Icon(
//                                Icons.arrow_downward,
//                                size: 50.0,
//                                color: Colors.white,
//                              ),
//                            ],
//                          ),
//                        )
//                  : Center(child: CircularProgressIndicator());
//            },
//          ),
    ])));
  }

  Future<List> _getWateredPlants() async {
    var res = await http.get("http://192.168.1.40:8080/wateredplant/user/${widget.userId}");
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return EditWateredPlantPage(widget.userId);
    }));
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
      await http.patch('http://192.168.1.40:8080/wateredplant/$plantId',
          body: jsonEncode({'lastDayWatering': newLastDayWatering}),
          headers: {'Content-Type': 'application/json'});

  _goToEditWateredPlant(int plantId) async {
    var wateredPlant = await _getWateredPlant(plantId);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return EditWateredPlantPage(widget.userId, wateredPlant: wateredPlant);
    }));
  }

  _goToLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return LoginPage();
    }));
  }

  Future<WateredPlant> _getWateredPlant(int plantId) async {
    var res = await http.get('http://192.168.1.40:8080/wateredplant/$plantId');
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
