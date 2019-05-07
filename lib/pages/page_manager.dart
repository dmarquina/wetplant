import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/fab_bottom_app_bar.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/pages/edit_watered_plant.dart';
import 'package:wetplant/pages/garden.dart';
import 'package:wetplant/pages/today.dart';
import 'package:wetplant/scoped_model/main_model.dart';

class PageManagerPage extends StatefulWidget {
  @override
  _PageManagerPageState createState() => _PageManagerPageState();
}

class _PageManagerPageState extends State<PageManagerPage> {
  int _selectedIndex = 0;
  final _widgetOptions = [TodayPage(), GardenPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SafeArea(child: ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            return Scaffold(
              body: CustomScrollColor(
                child: FutureBuilder(
                    future: model.getPlants(model.ownerId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return snapshot.connectionState == ConnectionState.done
                          ? _widgetOptions.elementAt(_selectedIndex)
                          : Center(child: CircularProgressIndicator());
                    }),
              ),
            );
          })),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: GreenMain,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return EditPlantPage();
              }));
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _getBottomNavigationBar());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBottomNavigationBar() {
    return FABBottomAppBar(
      centerItemText: 'Nueva planta',
      color: Colors.grey,
      selectedColor: GreenSecondMain,
      onTabSelected: _onItemTapped,
      items: [
        FABBottomAppBarItem(iconData: Icons.local_florist, text: 'Hoy'),
        FABBottomAppBarItem(iconData: Icons.list, text: 'Jardín')
      ],
    );
  }
}
