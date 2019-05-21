import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/page_title.dart';
import 'package:wetplant/components/garden_plant_card.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/pages/login.dart';
import 'package:wetplant/pages/plant_detail.dart';
import 'package:wetplant/scoped_model/main_model.dart';
import 'package:wetplant/util/menu_choice.dart';

class GardenPage extends StatefulWidget {
  @override
  _GardenPageState createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(140.0),
              child: AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: <Widget>[
                    PageTitle(title: 'Jardín', padding: EdgeInsets.only(top: 20, left: 10)),
                    PopupMenuButton<MenuChoice>(
                        padding: EdgeInsets.only(top: 20),
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
                  backgroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: false,
                  bottom: TabBar(
                      labelColor: GreenMain,
                      controller: _tabController,
                      tabs: [Tab(icon: Icon(Icons.view_list)), Tab(icon: Icon(Icons.grid_on))]))),
          body: CustomScrollColor(
              child: !model.actionInProgress
                  ? Container(
                      margin: EdgeInsets.only(top: 5),
                      child: TabBarView(
                          controller: _tabController, children: _buildTabViewContent(model)))
                  : Center(child: CircularProgressIndicator())));
    });
  }

  List<Widget> _buildTabViewContent(MainModel model) {
    var tabViewChildren = <Widget>[];
    if (model.gardenPlants != null && model.gardenPlants.isNotEmpty) {
      tabViewChildren.add(_buildPlantList(model));
      tabViewChildren.add(_buildGridPlant(model));
    } else {
      tabViewChildren.add(_buildNoPlantsText());
      tabViewChildren.add(_buildNoPlantsText());
    }
    return tabViewChildren;
  }

  Widget _buildPlantList(MainModel model) {
    return ListView(
        padding: EdgeInsets.symmetric(horizontal: 5),
        children: model.gardenPlants.map((gardenPlant) {
          return GardenPlantCard(gardenPlant);
        }).toList());
  }

  Widget _buildGridPlant(MainModel model) {
    return Container(
        child: GridView.count(
            shrinkWrap: true,
            primary: false,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            crossAxisCount: 3,
            children: model.gardenPlants.map((gp) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => PlantDetailPage(gp)));
                  },
                  child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(gp.plant.image ?? ''),
                              fit: BoxFit.cover))));
            }).toList()));
  }

  Widget _buildNoPlantsText() {
    return Container(
        margin: EdgeInsets.only(top: 150.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Aún no tienes ninguna planta guardada',
                style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.3))),
            SizedBox(height: 10.0),
            Text('¡Agrega una!', style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.3))),
            SizedBox(height: 30.0),
            Icon(Icons.arrow_downward, size: 50.0, color: Color.fromRGBO(0, 0, 0, 0.3))
          ],
        ));
  }
}
