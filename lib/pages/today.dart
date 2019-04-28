import 'package:flutter/material.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/no_flowers_to_water.dart';
import 'package:wetplant/components/page_title.dart';

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollColor(
        child: ListView(
      children: <Widget>[
        PageTitle(title: 'Hoy', padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: NoFlowersToWater(hasNoFlowers: true, hasCompleted: true),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: PageTitle(
                title: 'Atentidas', fontSize: 40, padding: EdgeInsets.fromLTRB(0, 20, 0, 16)))
      ],
    ));
  }
}
