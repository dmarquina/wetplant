import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/no_flowers_to_water.dart';
import 'package:wetplant/components/page_title.dart';
import 'package:wetplant/components/today_plant_card.dart';
import 'package:wetplant/scoped_model/main_model.dart';

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return CustomScrollColor(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView(children: _buildPage(model))));
    });
  }

  List<Widget> _buildPage(MainModel model) {
    List<Widget> children = List();
    children.add(PageTitle(title: 'Hoy', padding: EdgeInsets.symmetric(vertical: 20)));
    if (model.todayPlants.isEmpty) {
      children.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: NoFlowersToWater(hasNoFlowers: model.gardenPlants.isEmpty)));
    } else {
      children.add(_buildTodayPlants(model));
    }
    return children;
  }

  Widget _buildTodayPlants(MainModel model) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height + 425);
    final double itemWidth = (size.width * 2) - 50;
    var childAspectRadioValue = itemWidth / itemHeight;
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 15),
          shrinkWrap: true,
          primary: false,
          childAspectRatio: childAspectRadioValue,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 20.0,
          crossAxisCount: 2,
          children: model.todayPlants.map((gp) => TodayPlantCard(gp.plant, gp.reminders)).toList()),
    );
  }
}
