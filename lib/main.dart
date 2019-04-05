import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wetplant/pages/edit_watered_plant.dart';
import 'package:wetplant/pages/watered_plants.dart';

void main() {
//  debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wet Plant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routes: {
          '/': (BuildContext context) => WetPlantsPage(),
          '/edit': (BuildContext context) => EditWateredPlant()
        });
  }
}
