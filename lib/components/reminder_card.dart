import 'package:flutter/material.dart';
import 'package:wetplant/components/frequency_days.dart';
import 'package:wetplant/components/gradient_material_button.dart';
import 'package:wetplant/components/last_action_date.dart';
import 'package:wetplant/constants/available-reminders.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/reminder.dart';
import 'package:wetplant/util/reminder_type.dart';

class ReminderCard extends StatefulWidget {
  final AvailableReminder availableReminder;
  final Function addReminder;
  final Function deleteReminder;
  Reminder reminder;

  ReminderCard(this.availableReminder, this.addReminder, this.deleteReminder, {this.reminder});

  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  DateTime _datePicked;
  int _frequencyDays = 0;
  bool _editing = false;
  bool _reminderSelected = false;

  @override
  void initState() {
    _initValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ReminderType rType = widget.availableReminder.reminderType;
    return GestureDetector(
        onLongPress: () => _openDeleteReminderDialog(context),
        child: Container(
            width: 180,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
            decoration: _buildCardBoxDecoration(),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    onTap: () {
                      _openReminderDialog(context);
                    },
                    child: Stack(children: <Widget>[
                      Container(
                          alignment: Alignment(0, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(widget.availableReminder.title.toUpperCase(),
                                    style: TextStyle(fontSize: 20, color: Colors.black)),
                                Container(
                                    padding: ReminderType.Water != rType
                                        ? EdgeInsets.symmetric(vertical: 10.0)
                                        : EdgeInsets.only(),
                                    child: Icon(widget.availableReminder.iconData,
                                        color: _reminderSelected
                                            ? widget.availableReminder.primaryColor
                                            : GreyInactive,
                                        size: widget.availableReminder.size))
                              ]))
                    ])))));
  }

  _openReminderDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
                contentPadding: EdgeInsets.all(0),
                title: Text('RECORDATORIO DE ${widget.availableReminder.title.toUpperCase()}',
                    style: TextStyle(fontSize: 18.0)),
                children: <Widget>[
                  Container(width: MediaQuery.of(context).size.width),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('¿Cuándo fue la última vez?',
                          style: TextStyle(color: Colors.black54, fontSize: 16))),
                  Center(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                          LastActionDate(
                              widget.availableReminder.accentColor, _datePicked ?? DateTime.now(),
                              (date) {
                            _datePicked = date;
                          })
                        ])),
                  ),
                  FrequencyDays(
                      onChange: (int frequency) {
                        _frequencyDays = frequency;
                      },
                      initialValue: _frequencyDays,
                      type: "${widget.availableReminder.title} cada",
                      color: widget.availableReminder.accentColor),
                  Container(
                    alignment: Alignment.centerRight,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                          ButtonBar(children: <Widget>[
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8))),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('CANCELAR'),
                            ),
                            _buildAddButton()
                          ])
                        ])),
                  )
                ]));
  }

  Widget _buildAddButton() {
    return GradientButton(
        shadow: true,
        gradient: widget.availableReminder.gradientColor,
        height: 40,
        width: 120,
        buttonRadius: BorderRadius.all(Radius.circular(8)),
        onPressed: _addOrUpdateReminder,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _editing ? 'EDITAR' : 'AGREGAR',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ));
  }

  _openDeleteReminderDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                    '¿Deseas eliminar el recordatorio de ${widget.availableReminder.title.toUpperCase()}?',
                    style: TextStyle(fontSize: 16.0)),
                children: <Widget>[
                  ButtonBar(children: <Widget>[
                    FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('CANCELAR')),
                    FlatButton(
                        color: RedMain,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _deleteReminder();
                        },
                        child: Text('SI, ELIMINAR', style: TextStyle(color: Colors.white)))
                  ])
                ]));
  }

  _addOrUpdateReminder() {
    Reminder newReminder = Reminder(
        id: widget?.reminder?.id,
        postponedDays: widget?.reminder?.postponedDays,
        reminderType: widget.availableReminder.reminderType,
        lastDateAction: _datePicked,
        frequencyDays: _frequencyDays);
    widget.addReminder(newReminder);
    setState(() {
      _reminderSelected = true;
    });
    Navigator.pop(context);
  }

  _deleteReminder() {
    Reminder reminderToDelete;
    var idReminder = widget?.reminder?.id;
    if (idReminder != null) {
      reminderToDelete =
          Reminder(id: idReminder, reminderType: widget.availableReminder.reminderType);
      widget.reminder = null;
    } else {
      reminderToDelete = Reminder(reminderType: widget.availableReminder.reminderType);
    }
    widget.deleteReminder(reminderToDelete);
    setState(() {
      _initValues();
      _reminderSelected = false;
    });
  }

  _initValues() {
    _editing = widget.reminder != null;
    if (_editing) {
      _datePicked = widget.reminder.lastDateAction;
      _frequencyDays = widget.reminder.frequencyDays;
      _reminderSelected = true;
    } else {
      _datePicked = DateTime.now();
      _frequencyDays = widget.availableReminder.defaultFrequencyValue;
    }
  }

  BoxDecoration _buildCardBoxDecoration() {
    Color color = widget.availableReminder.accentColor;
    Color _kKeyUmbraOpacity = color.withAlpha(51);
    Color _kKeyPenumbraOpacity = color.withAlpha(36);
    Color _kAmbientShadowOpacity = color.withAlpha(31);
    return BoxDecoration(
      color: Colors.white,
      boxShadow: <BoxShadow>[
        BoxShadow(
            offset: Offset(0.0, 2.0),
            blurRadius: 4.0,
            spreadRadius: -1.0,
            color: _kKeyUmbraOpacity),
        BoxShadow(
            offset: Offset(0.0, 4.0),
            blurRadius: 5.0,
            spreadRadius: 0.0,
            color: _kKeyPenumbraOpacity),
        BoxShadow(
            offset: Offset(0.0, 1.0),
            blurRadius: 10.0,
            spreadRadius: 0.0,
            color: _kAmbientShadowOpacity),
      ],
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    );
  }
}
