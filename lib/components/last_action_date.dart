import 'package:flutter/material.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/util/date_util.dart';

class LastActionDate extends StatefulWidget {
  final Color color;
  final DateTime initValue;
  final Function(DateTime) pickDate;
  DateTime lastTimeAction;

  LastActionDate(this.color, this.initValue, this.pickDate, {this.lastTimeAction});

  @override
  _LastActionDateState createState() => _LastActionDateState();
}

class _LastActionDateState extends State<LastActionDate> {
  LastActionDates lastDateSelected = LastActionDates.today;
  DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
  DateTime today = DateTime.now();
  String dateSelected;

  @override
  void initState() {
    if (!checkDatesAreEquals(widget.initValue, today)) {
      if (checkDatesAreEquals(widget.initValue, yesterday)) {
        _pickDate(yesterday, LastActionDates.yesterday);
      } else {
        _pickDate(widget.initValue, LastActionDates.date);
      }
    } else {
      _pickDate(today, LastActionDates.today);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        child: Column(children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                    onPressed: () => _pickDate(yesterday, LastActionDates.yesterday),
                    color:
                        lastDateSelected == LastActionDates.yesterday ? widget.color : GreyInactive,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(20))),
                    child: Text('Ayer', style: TextStyle(color: Colors.white))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: FlatButton(
                      onPressed: () => _pickDate(today, LastActionDates.today),
                      color:
                          lastDateSelected == LastActionDates.today ? widget.color : GreyInactive,
                      child: Text('Hoy', style: TextStyle(color: Colors.white))),
                ),
                FlatButton(
                    onPressed: () => _selectDate(context),
                    color: lastDateSelected == LastActionDates.date ? widget.color : GreyInactive,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(20))),
                    child:
                        Text(dateSelected ?? 'Otra Fecha', style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ]));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: widget.lastTimeAction ?? DateTime(2019),
        lastDate: today);
    _pickDate(picked, LastActionDates.date);
  }

  _pickDate(DateTime picked, LastActionDates day) {
    if (picked != null) {
      switch (day) {
        case LastActionDates.yesterday:
          lastDateSelected = LastActionDates.yesterday;
          picked = yesterday;
          dateSelected = null;
          break;
        case LastActionDates.today:
          lastDateSelected = LastActionDates.today;
          picked = today;
          dateSelected = null;
          break;
        case LastActionDates.date:
          lastDateSelected = LastActionDates.date;
          dateSelected = formatDate(picked);
          break;
      }
      setState(() {
        widget.pickDate(picked);
//        _dateTextToSave = picked.toIso8601String();
      });
    }
  }

  String formatDate(DateTime date) {
    String day = date.day < 10 ? '0' + date.day.toString() : date.day.toString();
    String month = date.month < 10 ? '0' + date.month.toString() : date.month.toString();
    return '$day/$month';
  }
}
