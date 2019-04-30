import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/pages/login.dart';
import 'package:wetplant/scoped_model/main_model.dart';
import 'package:wetplant/util/my_http_override.dart';

void main() {
//  debugPaintSizeEnabled = true;
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MainModel _model = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
          title: 'SucuCactu',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.green,
              backgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                  color: Colors.white10,
                  iconTheme: IconThemeData(color: Colors.black),
                  textTheme: TextTheme(
                      title:
                          TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
                      headline: TextStyle(color: Colors.black)))),
          home: LoginPage()),
    );
  }
}
