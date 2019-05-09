import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/gradient_material_button.dart';
import 'package:wetplant/components/image_input.dart';
import 'package:wetplant/components/reminder_card.dart';
import 'package:wetplant/constants/available-reminders.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/plant.dart';
import 'package:wetplant/model/reminder.dart';
import 'package:wetplant/scoped_model/main_model.dart';
import 'package:wetplant/util/reminder_type.dart';

class EditPlantPage extends StatefulWidget {
  final Plant plant;

  EditPlantPage({this.plant});

  @override
  EditPlantPageState createState() {
    return new EditPlantPageState();
  }
}

class EditPlantPageState extends State<EditPlantPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<ReminderType, Reminder> _reminders = Map();

  final _nameTextController = TextEditingController(text: '');
  File _imageFile;
  String _imagePlant = '';
  String _appBarTitle = 'NUEVA PLANTA';
  String _waitingMessage = 'Publicando tu nueva plantita';
  bool _waitingAction = false;
  bool _valid = false;
  RegExp numberRegExp = RegExp(r"^[0-9]*$");

  @override
  void initState() {
    if (widget.plant != null) {
      _nameTextController.text = widget.plant.name;
//      _imagePlant = widget.plant.image;
      _appBarTitle = 'EDITAR PLANTA';
      _waitingMessage = 'Editando tu querida plantita';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _waitingAction
        ? Scaffold(
            body: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 10.0),
            Text(_waitingMessage)
          ])))
        : Scaffold(
            appBar: AppBar(
              centerTitle: false,
              elevation: 0.0,
              title: Text(_appBarTitle),
            ),
            body: CustomScrollColor(
                child: ListView(children: <Widget>[
              Form(
                  key: _formKey,
                  child: Container(
                      padding: EdgeInsets.all(15.0),
                      child:
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        ImageInput(onSave: (File imageFileSource) {
                          _setImageFile(imageFileSource);
                        }),
                        _buildPlantNameField(),
                        SizedBox(height: 20.0),
                        Text('RECORDATORIOS',
                            style: TextStyle(color: Colors.black45, fontSize: 16)),
                        _valid
                            ? Text('Selecciona almenos un recordatorio.',
                                style: TextStyle(color: Colors.red, fontSize: 10.0))
                            : Container(),
                        _buildGridReminders(),
                        _buildCreateEditPlantButton()
                      ])))
            ])));
  }

  _addReminders(Reminder reminder) => _reminders[reminder.reminderType] = reminder;

  _deleteReminder(Reminder reminder) => _reminders.remove(reminder.reminderType);

  Widget _buildPlantNameField() {
    return TextFormField(
      controller: _nameTextController,
      decoration: InputDecoration(helperText: 'Nombre'),
      maxLength: 32,
      validator: (String value) {
        if (value.isEmpty || value.length < 0) return 'Tu planta debe tener un nombre';
      },
    );
  }

  Widget _buildGridReminders() {
    return Container(
        padding: EdgeInsets.only(top: 24),
        child: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            childAspectRatio: 1.6,
            primary: false,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 12.0,
            crossAxisCount: 2,
            children: availableReminders.map((availableReminder) {
              return ReminderCard(
                  availableReminder, (r) => _addReminders(r), (r) => _deleteReminder(r));
            }).toList()));
  }

  Widget _buildCreateEditPlantButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 24, 0, 24),
        child: GradientButton(
            shadow: true,
            gradient: GreenGradient,
            height: 60,
            buttonRadius: BorderRadius.all(Radius.circular(8)),
            onPressed: () {
              _saveNewWateredPlant(model);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'AGREGAR PLANTA',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            )),
      );
    });
  }

  _setImageFile(File imageFileSource) {
    _imageFile = imageFileSource;
  }

  _saveNewWateredPlant(MainModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (_reminders.isEmpty) {
      setState(() {
        _valid = true;
      });
      return;
    } else {
      _valid = false;
    }
    setState(() {
      _waitingAction = true;
    });
    Map<String, dynamic> jsonNewPlant = {
      'ownerId': model.ownerId,
      'name': _nameTextController.text,
      'reminders': _getJsonReminders(_reminders)
    };
    await model.addNewPlant(jsonNewPlant, _imageFile);
    Navigator.pop(context);
  }

  List<Map<String,dynamic>> _getJsonReminders(Map reminders) {
    return reminders.values.map((reminder) =>
    {
      'name': reminder.reminderType == ReminderType.Water ? 'water' : 'fertilaze',
      'frequencyDays': reminder.frequencyDays,
      'lastDateAction': reminder.lastDateAction.toIso8601String(),
    }).toList();
  }
}
