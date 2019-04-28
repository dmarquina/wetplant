import 'package:flutter/material.dart';
import 'package:wetplant/components/fab_bottom_app_bar.dart';
import 'package:wetplant/pages/today.dart';
import 'package:wetplant/pages/watered_plants.dart';
import 'package:wetplant/constants/colors';

class PageManagerPage extends StatefulWidget {
  final String userId;

  PageManagerPage(this.userId);

  @override
  _PageManagerPageState createState() => _PageManagerPageState();
}

class _PageManagerPageState extends State<PageManagerPage> {
  int _selectedIndex = 0;
  final _widgetOptions = [
    TodayPage(),
    WateredPlantsPage('sSMpDLjiadWuE10CVQiRrGCJI6w2')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: GreenMain,
            onPressed: () {},
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
