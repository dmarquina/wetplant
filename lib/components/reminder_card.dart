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

  ReminderCard(this.availableReminder, this.addReminder, this.deleteReminder);

  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  DateTime datePicked;
  int frequencyDays = 0;
  Map<ReminderType, bool> _remindersSelected = Map();

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
                  _openDialog(context);
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
                                    color: _remindersSelected[rType] != null &&
                                            _remindersSelected[rType]
                                        ? widget.availableReminder.primaryColor
                                        : GreyInactive,
                                    size: widget.availableReminder.size)),
//                          _buildReminderInfo()
                          ]))
                ]))),
      ),
    );
  }

  _openDialog(BuildContext context) {
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
                              widget.availableReminder.accentColor, datePicked ?? DateTime.now(),
                              (date) {
                            datePicked = date;
                          })
                        ])),
                  ),
                  FrequencyDays(
                      onChange: (int frequency) {
                        frequencyDays = frequency;
                      },
                      initialValue: frequencyDays,
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

  _openDeleteReminderDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                    'Eliminar recordatorio de ${widget.availableReminder.title.toLowerCase()}',
                    style: TextStyle(fontSize: 16.0)),
                children: <Widget>[
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('CANCELAR'),
                      ),
                      FlatButton(
                        color: RedMain,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        onPressed: () {
                          _deleteReminder();
                          Navigator.of(context).pop();
                        },
                        child: Text('SI', style: TextStyle(color: Colors.white)),
                      )
                    ],
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
        onPressed: _addReminder,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'AGREGAR',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ));
  }

  _addReminder() {
    Reminder newReminder = Reminder(
        reminderType: widget.availableReminder.reminderType,
        lastDateAction: datePicked,
        frequencyDays: frequencyDays);
    widget.addReminder(newReminder);
    setState(() {
      _remindersSelected[widget.availableReminder.reminderType] = true;
    });
    Navigator.pop(context);
  }

  _deleteReminder() {
    Reminder reminderToDelete = Reminder(
        reminderType: widget.availableReminder.reminderType,
        lastDateAction: datePicked,
        frequencyDays: frequencyDays);
    widget.deleteReminder(reminderToDelete);
    setState(() {
      _initValues();
      _remindersSelected[widget.availableReminder.reminderType] = false;
    });
  }

  _initValues() {
    datePicked = DateTime.now();
    frequencyDays = widget.availableReminder.defaultFrequencyValue;
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
