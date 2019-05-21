import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/no_plants_to_take_action.dart';
import 'package:wetplant/components/page_title.dart';
import 'package:wetplant/components/quick_action_bar/quick_action_bar.dart';
import 'package:wetplant/components/today_plant_card.dart';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/pages/login.dart';
import 'package:wetplant/pages/plant_detail.dart';
import 'package:wetplant/scoped_model/main_model.dart';
import 'package:wetplant/util/menu_choice.dart';

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  List<int> _selectedIds = [];

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(_selectedIds.length >= 1 ? 160.0 : 120),
              child: AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace:
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                      PageTitle(title: 'Hoy', padding: EdgeInsets.only(top: 20, left: 10)),
                      PopupMenuButton<MenuChoice>(padding: EdgeInsets.only(top: 20),
                          icon: Icon(Icons.more_vert, color: Colors.black26),
                          onSelected: (menuChoice) {
                            model.logout();
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem<MenuChoice>(
                                  value: userMenuChoices[0], child: Text(userMenuChoices[0].title))
                            ];
                          })
                    ]),
                    _buildQuickActionBar(model)
                  ]),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: false)),
          body: CustomScrollColor(
              child: Container(
                  child: !model.actionInProgress
                      ? ListView(children: _buildPage(model))
                      : Center(child: CircularProgressIndicator()))));
    });
  }

  List<Widget> _buildPage(MainModel model) {
    List<Widget> children = List();

    if (model.todayPlants.isNotEmpty) {
      children.add(_buildTodayPlants(model));
    } else {
      children.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: NoPlantsToTakeAction(hasNoFlowers: model.gardenPlants.isEmpty)));
    }
    return children;
  }

  Widget _buildTodayPlants(MainModel model) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height + 410);
    final double itemWidth = (size.width * 2) - 30;
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
          children: model.todayPlants
              .map((gp) => TodayPlantCard(gp, model, _selectedIds.contains(gp.plant.id),
                      onLongPress: (GardenPlant gardenPlant) {
                    if (_selectedIds.contains(gardenPlant.plant.id)) {
                      setState(() {
                        _selectedIds.remove(gardenPlant.plant.id);
                      });
                    } else {
                      setState(() {
                        _selectedIds.add(gardenPlant.plant.id);
                      });
                    }
                  }, onPress: (GardenPlant gardenPlant) {
                    if (_selectedIds.contains(gardenPlant.plant.id)) {
                      setState(() {
                        _selectedIds.remove(gardenPlant.plant.id);
                      });
                    } else if (_selectedIds.length > 0) {
                      setState(() {
                        _selectedIds.add(gardenPlant.plant.id);
                      });
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PlantDetailPage(gardenPlant)));
                    }
                  }))
              .toList()),
    );
  }

  Widget _buildQuickActionBar(MainModel model) {
    return _selectedIds.length >= 1
        ? QuickActionBar(
            gardenPlants: model.todayPlants.where((gardenPlant) {
              return _selectedIds.contains(gardenPlant.plant.id);
            }).toList(),
            onAction: () {
              setState(() {
                _selectedIds = [];
              });
            },
            model: model)
        : Container();
  }
}
