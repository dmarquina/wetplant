import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/page_title.dart';
import 'package:wetplant/components/garden_plant_card.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/garden_plant.dart';
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
      return Scaffold(body: CustomScrollColor(child: _buildTitleAndPlantList(model.gardenPlants)));
    });
  }

  Widget _buildTitleAndPlantList(List<GardenPlant> gardenPlantList) {
    var children = <Widget>[];
    children.add(PageTitle(title: 'Jardín'));
    children.add(DefaultTabController(
      length: 3,
      child: TabBar(
        labelColor: GreenMain,
        tabs: [
          Tab(icon: Icon(Icons.view_list)),
          Tab(icon: Icon(Icons.grid_on)),
        ],
      ),
    ));
    children.add(SizedBox(height: 10.0));
    if (gardenPlantList != null && gardenPlantList.length > 0) {
      children.addAll(_buildPlantList(gardenPlantList));
    } else {
      children.add(_buildNoPlants());
    }
    return ListView(padding: EdgeInsets.symmetric(horizontal: 10), children: children);
  }

  List<Widget> _buildPlantList(List<GardenPlant> gardenPlantList) {
    return gardenPlantList.map((gp) {

      return GardenPlantCard(gp.plant,gp.reminders);
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
