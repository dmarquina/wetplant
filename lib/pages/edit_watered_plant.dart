import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:wetplant/model/watered_plant.dart';
import 'package:wetplant/util/image_input.dart';

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
  File imageFile;
  String _dateTextToSave = '';
  String _imagePlant = '';
  String _appBarTitle = 'Nueva plantita';
  String _waitingMessage = 'Publicando tu nueva plantita';
  bool _waitingAction = false;
  bool _validate = false;

  @override
  void initState() {
    if (widget.wateredPlant != null) {
      _nameTextController.text = widget.wateredPlant.name;
      _minDaysTextController.text = widget.wateredPlant.minWateringDays.toString();
      _maxDaysTextController.text = widget.wateredPlant.maxWateringDays.toString();
      _imagePlant = widget.wateredPlant.image;
      _dateTextController.text = formatDate(DateTime.parse(widget.wateredPlant.lastDayWatering));
      _dateTextToSave = widget.wateredPlant.lastDayWatering;
      _appBarTitle = 'Editar plantita';
      _waitingMessage = 'Editando tu querida plantita';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RegExp numberRegExp = RegExp(r"^[0-9]*$");
    return _waitingAction
        ? Scaffold(
            body: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 10.0),
            Text(_waitingMessage)
          ])))
        : Scaffold(backgroundColor: Colors.green,
            appBar: AppBar(elevation: 0.0,
              leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: _goToWetPlantsPage),
              title: Text(_appBarTitle),
            ),
            body: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              elevation: 4.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      padding: EdgeInsets.all(15.0),
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
                                        inputFormatters: [
                                          WhitelistingTextInputFormatter(numberRegExp)
                                        ],
                                        validator: (String value) {
                                          if (value.isEmpty) return 'No puede ser vacio';
                                          if (int.parse(value) < 0)
                                            return 'Debe ser un número mayor a 0';
                                        },
                                        controller: _minDaysTextController,
                                        decoration:
                                            InputDecoration(helperText: 'Min. Días', counterText: ''),
                                        maxLength: 2))),
                            Flexible(
                                child: Container(
                                    padding: EdgeInsets.only(left: 15.0),
                                    child: TextFormField(
                                        inputFormatters: [
                                          WhitelistingTextInputFormatter(numberRegExp)
                                        ],
                                        validator: (String value) {
                                          if (value.isEmpty) return 'No puede ser vacio';
                                          if (int.parse(value) <
                                              int.parse(_minDaysTextController.text))
                                            return 'Debe ser mayor a Min. Días';
                                        },
                                        controller: _maxDaysTextController,
                                        decoration:
                                            InputDecoration(helperText: 'Max. Días', counterText: ''),
                                        maxLength: 2))),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Container(
                            child: TextField(
                                enableInteractiveSelection: false,
                                focusNode: FocusNode(),
                                onTap: () => _selectDate(context),
                                controller: _dateTextController,
                                decoration: InputDecoration(
                                  helperText: 'Último día de regado',
                                  errorText: _validate ? 'Debes ingresar una fecha' : null,
                                ))),
                        SizedBox(height: 5.0),
                        ImageInput(setImageFile, _imagePlant),
                        Container(
                            width: double.infinity,
                            child: RaisedButton(
                                color: Colors.green,
                                onPressed: widget.wateredPlant == null
                                    ? _saveNewWateredPlant
                                    : _updateWateredPlant,
                                child: Text('Guardar', style: TextStyle(color: Colors.white))))
                      ]))),
            ));
  }

  setImageFile(File imageFileSource) {
    imageFile = imageFileSource;
  }

  DateTime today = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context, initialDate: today, firstDate: DateTime(2018), lastDate: today);

    if (picked != null)
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
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (_dateTextToSave.isEmpty) {
      _validate = true;
    }
    setState(() {
      _waitingAction = true;
    });
    Map<String, dynamic> jsonWateredPlant = {
      'lastDayWatering': _dateTextToSave,
      'minWateringDays': _minDaysTextController.text,
      'maxWateringDays': _maxDaysTextController.text,
      'name': _nameTextController.text
    };
    http.Response res = await http.post("http://192.168.1.45:8080/wateredplant/",
        body: jsonEncode(jsonWateredPlant), headers: {'Content-Type': 'application/json'});
    await _addImage(jsonDecode(res.body)['id'].toString(), imageFile);
    _goToWetPlantsPage();
  }

  _updateWateredPlant() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (_dateTextToSave.isEmpty) {
      _validate = true;
    }
    setState(() {
      _waitingAction = true;
    });
    Map<String, dynamic> jsonWateredPlant = {
      'id': widget.wateredPlant.id.toString(),
      'lastDayWatering': _dateTextToSave,
      'minWateringDays': _minDaysTextController.text,
      'maxWateringDays': _maxDaysTextController.text,
      'name': _nameTextController.text,
      'image': _imagePlant
    };
    http.Response res = await http.put("http://192.168.1.45:8080/wateredplant/",
        body: jsonEncode(jsonWateredPlant), headers: {'Content-Type': 'application/json'});
    if (imageFile != null) {
      await _addImage(jsonDecode(res.body)['id'].toString(), imageFile);
    }
    _goToWetPlantsPage();
  }

  Future<http.StreamedResponse> _addImage(String id, File image) {
    var url = Uri.parse("http://192.168.1.45:8080/wateredplant/image");
    var request = new http.MultipartRequest("POST", url);
    request.headers['content-type'] = 'multipart/form-data';
    request.fields['id'] = id;
    request.files.add(new http.MultipartFile.fromBytes("image", image.readAsBytesSync(),
        contentType: MediaType.parse('multipart/form-data'), filename: 'image'));
    return request.send();
  }

  _goToWetPlantsPage() {
    Navigator.pushReplacementNamed(context, '/');
  }
}
