import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/pages/login.dart';
import 'package:wetplant/pages/manager.dart';
import 'package:wetplant/scoped_model/main_model.dart';
import 'package:wetplant/util/my_http_override.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

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
          home: _isAuthenticated ? PageManagerPage(_model) : LoginPage()),
    );
  }
}
