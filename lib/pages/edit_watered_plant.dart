import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wetplant/model/watered_plant.dart';
import 'package:wetplant/pages/watered_plants.dart';

class EditWateredPlant extends StatefulWidget {
  final WateredPlant wateredPlant;

  EditWateredPlant({this.wateredPlant});

  @override
  EditWateredPlantState createState() {
    return new EditWateredPlantState();
  }
}

class EditWateredPlantState extends State<EditWateredPlant> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController(text: '');
  final _minDaysTextController = TextEditingController(text: '');
  final _maxDaysTextController = TextEditingController(text: '');
  final _dateTextController = TextEditingController(text: '');
  String _dateTextToSave = '';
  bool _disabledSaveButton = false;
  bool _validate = false;

  @override
  void initState() {
    if (widget.wateredPlant != null) {
      _nameTextController.text = widget.wateredPlant.plant.name;
      _minDaysTextController.text = widget.wateredPlant.minWateringDays.toString();
      _maxDaysTextController.text = widget.wateredPlant.maxWateringDays.toString();
      _dateTextController.text = formatDate(DateTime.parse(widget.wateredPlant.lastDayWatering));
      _dateTextToSave = widget.wateredPlant.lastDayWatering;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RegExp numberRegExp = RegExp(r"^[0-9]*$");
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.wateredPlant == null ? 'Nueva Planta' : 'Editar Planta'),
        ),
        body: Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: _nameTextController,
                    decoration: InputDecoration(helperText: 'Nombre'),
                    maxLength: 35,
                    validator: (String value) {
                      if (value.isEmpty || value.length < 0) return 'Debe tener un nombre';
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                          child: Container(
                              padding: EdgeInsets.only(right: 15.0),
                              child: TextFormField(
                                  inputFormatters: [WhitelistingTextInputFormatter(numberRegExp)],
                                  validator: (String value) {
                                    if (value.isEmpty) return 'No puede ser vacio';
                                    if (int.parse(value) < 0) return 'Debe ser un número mayor a 0';
                                  },
                                  controller: _minDaysTextController,
                                  decoration:
                                      InputDecoration(helperText: 'Min. Días', counterText: ''),
                                  maxLength: 2))),
                      Flexible(
                          child: Container(
                              padding: EdgeInsets.only(left: 15.0),
                              child: TextFormField(
                                  inputFormatters: [WhitelistingTextInputFormatter(numberRegExp)],
                                  validator: (String value) {
                                    if (value.isEmpty) return 'No puede ser vacio';
                                    if (int.parse(value) < int.parse(_minDaysTextController.text))
                                      return 'Debe ser menor a Min. Días';
                                  },
                                  controller: _maxDaysTextController,
                                  decoration:
                                      InputDecoration(helperText: 'Max. Días', counterText: ''),
                                  maxLength: 2))),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Flexible(
                      child: TextField(
                          onTap: () => _selectDate(context),
                          controller: _dateTextController,
                          decoration: InputDecoration(
                            helperText: 'Último día de regado',
                            errorText: _validate ? 'Debes ingresar una fecha' : null,
                          ))),
                  SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                        color: Colors.green,
                        onPressed: _disabledSaveButton
                            ? null
                            : widget.wateredPlant == null
                                ? _saveNewWateredPlant
                                : _updateWateredPlant,
                        child: Text('Guardar', style: TextStyle(color: Colors.white))),
                  )
                ]))));
  }

  DateTime today = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context, initialDate: today, firstDate: DateTime(2018), lastDate: today);

    if (picked != null && picked != today)
      setState(() {
        _dateTextController.text = formatDate(picked);
        _dateTextToSave = picked.toIso8601String();
        _validate = false;
      });
  }

  String formatDate(DateTime date) {
    String day = date.day < 10 ? '0' + date.day.toString() : date.day.toString();
    String month = date.month < 10 ? '0' + date.month.toString() : date.month.toString();
    return '$day-$month-${date.year.toString()}';
  }

  _saveNewWateredPlant() async {
    if (!_formKey.currentState.validate() || _dateTextToSave.isEmpty) {
      _validate = true;
      return;
    }
    _disabledSaveButton = true;
    Map<String, dynamic> jsonWateredPlant = {
      'lastDayWatering': _dateTextToSave,
      'minWateringDays': _minDaysTextController.text,
      'maxWateringDays': _maxDaysTextController.text,
      'name': _nameTextController.text,
      'image': 'http://wtf.com?nosequemas'
    };
    await http.post("http://192.168.1.40:8080/wateredplant/",
        body: jsonEncode(jsonWateredPlant), headers: {'Content-Type': 'application/json'});
    _disabledSaveButton = false;
    _goToWetPlantsPage();
  }

  _updateWateredPlant() async {
    if (!_formKey.currentState.validate() || _dateTextToSave.isEmpty) {
      _validate = true;
      return;
    }
    _disabledSaveButton = true;
    Map<String, dynamic> jsonWateredPlant = {
      'id': widget.wateredPlant.id.toString(),
      'plantId': widget.wateredPlant.plant.id.toString(),
      'lastDayWatering': _dateTextToSave,
      'minWateringDays': _minDaysTextController.text,
      'maxWateringDays': _maxDaysTextController.text,
      'name': _nameTextController.text,
      'image': 'http://wtf.com?nosequemas'
    };
    await http.put("http://192.168.1.40:8080/wateredplant/",
        body: jsonEncode(jsonWateredPlant), headers: {'Content-Type': 'application/json'});
    _disabledSaveButton = false;
    _goToWetPlantsPage();
  }

  _goToWetPlantsPage() {
    Navigator.pop(context);
  }
}
