import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/page_title.dart';
import 'package:wetplant/components/plant_card.dart';
import 'package:wetplant/model/plant.dart';
import 'package:wetplant/scoped_model/main_model.dart';

class GardenPage extends StatefulWidget {
  @override
  _GardenPageState createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
            body: CustomScrollColor(
              child: FutureBuilder(
                  future: model.getMyPlants('sSMpDLjiadWuE10CVQiRrGCJI6w2'),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    final List<Plant> wateredPlantList = snapshot.data;
                    return snapshot.connectionState == ConnectionState.done
                        ? _buildTitleAndPlantList(wateredPlantList)
                        : Center(child: CircularProgressIndicator());
                  }),
            ),
          );
        });
  }

  Widget _buildTitleAndPlantList(List<Plant> wateredPlantList) {
    var children = <Widget>[];
    children.add(PageTitle(title: 'Jardín'));
    if (wateredPlantList != null && wateredPlantList.length > 0) {
      children.addAll(_buildPlantList(wateredPlantList));
    } else {
      children.add(_buildNoPlants());
    }
    return ListView(padding: EdgeInsets.symmetric(horizontal: 16), children: children);
  }

  List<Widget> _buildPlantList(List<Plant> wateredPlantList) {
    return wateredPlantList.map((p) {
      int plantId = p.id;
      String plantName = p.name;
      String plantImage = p.image;
      int minDays = p.minWateringDays;
      int maxDays = p.maxWateringDays;
      int actualDays = p.daysSinceLastDayWatering;
      return PlantCard(plantId, plantName, plantImage, minDays, actualDays);
    }).toList();
  }

  Widget _buildNoPlants() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Aún no tienes ninguna planta guardada', style: TextStyle(color: Colors.white)),
          SizedBox(height: 10.0),
          Text('Agrega una', style: TextStyle(color: Colors.white)),
          SizedBox(height: 30.0),
          Icon(
            Icons.arrow_downward,
            size: 50.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
