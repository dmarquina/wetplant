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

class PlantEditPage extends StatefulWidget {
  final GardenPlant gardenPlant;

  PlantEditPage({this.gardenPlant});

  @override
  PlantEditPageState createState() {
    return new PlantEditPageState();
  }
}

class PlantEditPageState extends State<PlantEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<ReminderType, Reminder> _localReminders = Map();
  List<int> _remindersToDelete = [];

  bool _editing = false;
  final _nameTextController = TextEditingController(text: '');
  File _imageFile;
  bool _valid = false;
  bool _waitingAction = false;

  @override
  void initState() {
    if (widget.gardenPlant != null) {
      _editing = true;
      _nameTextController.text = widget.gardenPlant.plant.name;
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
            Text('${_editing ? 'Editando tu querida' : 'Publicando tu nueva'} plantita')
          ])))
        : Scaffold(
            appBar: AppBar(
                centerTitle: false,
                elevation: 0.0,
                title: Text('${_editing ? 'EDITAR' : 'NUEVA'} PLANTA')),
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
                              actualImage: widget?.gardenPlant?.plant?.image ?? null),
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
                  availableReminder, (r) => _addReminders(r), (r) => _deleteReminder(r),
                  reminder: _localReminders[availableReminder.reminderType]);
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
      _localReminders[reminder.reminderType] = reminder;
    });
  }

  _deleteReminder(Reminder reminder) {
    if (reminder.id != null) {
      _remindersToDelete.add(reminder.id);
    }
    setState(() {
      _localReminders.remove(reminder.reminderType);
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
                '${_editing ? 'EDITAR' : 'AGREGAR'} PLANTA',
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
    if (_localReminders.isEmpty) {
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
      'ownerId': model.ownerId,
      'name': _nameTextController.text,
      'reminders': _getJsonReminders(_localReminders),
      'remindersToDelete': _remindersToDelete
    };
    _editing
        ? await model.updatePlant(jsonNewPlant,widget.gardenPlant.plant.image, _imageFile)
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
