import 'package:flutter/material.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/pages/login.dart';

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
        home: LoginPage());
  }
}
