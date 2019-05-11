import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/gradient_material_button.dart';
import 'package:wetplant/components/image_input.dart';
import 'package:wetplant/components/reminder_card.dart';
import 'package:wetplant/constants/available-reminders.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/model/reminder.dart';
import 'package:wetplant/pages/page_manager.dart';
import 'package:wetplant/scoped_model/main_model.dart';
import 'package:wetplant/util/reminder_type.dart';

class EditPlantPage extends StatefulWidget {
  final GardenPlant gardenPlant;

  EditPlantPage({this.gardenPlant});

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
  bool _editing = false;
  String _appBarTitle = 'NUEVA PLANTA';
  String _waitingMessage = 'Publicando tu nueva plantita';
  String _buttonText = 'AGREGAR PLANTA';
  String _actualImage;
  bool _waitingAction = false;
  bool _valid = false;
  RegExp numberRegExp = RegExp(r"^[0-9]*$");

  @override
  void initState() {
    if (widget.gardenPlant != null) {
      _editing = true;
      _nameTextController.text = widget.gardenPlant.plant.name;
      _appBarTitle = 'EDITAR PLANTA';
      _waitingMessage = 'Editando tu querida plantita';
      _buttonText = 'EDITAR PLANTA';
      _actualImage = widget.gardenPlant.plant.image;
      getReminderByType();
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
            body: ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
              return CustomScrollColor(
                  child: ListView(children: <Widget>[
                Form(
                    key: _formKey,
                    child: Container(
                        padding: EdgeInsets.all(15.0),
                        child:
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                          ImageInput(
                              onSave: (File imageFileSource) {
                                _setImageFile(imageFileSource);
                              },
                              actualImage: _actualImage),
                          _buildPlantNameField(),
                          SizedBox(height: 20.0),
                          Text('RECORDATORIOS',
                              style: TextStyle(color: Colors.black45, fontSize: 16)),
                          Text('(Manten presionado para eliminar)',
                              style: TextStyle(fontSize: 9, fontStyle: FontStyle.italic)),
                          _valid
                              ? Text('Selecciona almenos un recordatorio.',
                                  style: TextStyle(color: Colors.red, fontSize: 10.0))
                              : Container(),
                          _buildGridReminders(),
                          _buildCreateEditPlantButton(model)
                        ])))
              ]));
            }));
  }

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
                availableReminder,
                (r) => _addReminders(r),
                (r) => _deleteReminder(r),
                reminder: _reminders[availableReminder.reminderType],
                countRemindersInMemory: _reminders.length,
              );
            }).toList()));
  }

  getReminderByType() {
    availableReminders.forEach((ar) {
      Reminder reminder;
      try {
        if (widget.gardenPlant != null && widget.gardenPlant.reminders.isNotEmpty) {
          reminder =
              widget.gardenPlant.reminders.firstWhere((rem) => rem.reminderType == ar.reminderType);
          _addReminders(reminder);
        }
      } catch (Exception) {}
    });
  }

  _addReminders(Reminder reminder) {
    setState(() {
      _reminders[reminder.reminderType] = reminder;
    });
  }

  _deleteReminder(Reminder reminder) {
    if (reminder.id != null) {
      //TODO: Metodo para eliminar en back
      print(reminder.id);
//        model.plantDetailReminders.removeWhere((r) => r.id == reminder.id);
    }
    setState(() {
      _reminders.remove(reminder.reminderType);
    });
  }

  Widget _buildCreateEditPlantButton(MainModel model) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 24, 0, 24),
      child: GradientButton(
          shadow: true,
          gradient: GreenGradient,
          height: 60,
          buttonRadius: BorderRadius.all(Radius.circular(8)),
          onPressed: () {
            _saveOrUpdatePlant(model);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_buttonText',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          )),
    );
  }

  _setImageFile(File imageFileSource) {
    _imageFile = imageFileSource;
  }

  _saveOrUpdatePlant(MainModel model) async {
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
      'id': _editing ? widget.gardenPlant.plant.id : null,
      'image': _editing ? widget.gardenPlant.plant.image : null,
      'ownerId': model.ownerId,
      'name': _nameTextController.text,
      'reminders': _getJsonReminders(_reminders)
    };
    _editing
        ? await model.updatePlant(jsonNewPlant, _imageFile)
        : await model.addPlant(jsonNewPlant, _imageFile);
    Navigator.pushReplacement(context,
        MaterialPageRoute<bool>(builder: (BuildContext context) => PageManagerPage(model)));
  }

  List<Map<String, dynamic>> _getJsonReminders(Map reminders) {
    return reminders.values
        .map((reminder) => {
              'id': reminder.id,
              'postponedDays': reminder.postponedDays,
              'name': reminder.reminderType == ReminderType.Water ? 'water' : 'fertilaze',
              'frequencyDays': reminder.frequencyDays,
              'lastDateAction': reminder.lastDateAction.toIso8601String(),
            })
        .toList();
  }
}
