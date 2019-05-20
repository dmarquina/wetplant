import 'package:flutter/material.dart';
import 'package:wetplant/components/frequency_days.dart';
import 'package:wetplant/components/gradient_material_button.dart';
import 'package:wetplant/components/last_action_date.dart';
import 'package:wetplant/constants/colors';

class MultipleActionDialog extends StatefulWidget {
  final int amount;
  final String title;
  final String action;
  final String bodyText;
  final LinearGradient gradientColor;
  final Color accentColor;
  final Function(DateTime) onActionPress;
  final Function(int days) onPostponePress;

  MultipleActionDialog({
    @required this.amount,
    @required this.title,
    @required this.action,
    @required this.bodyText,
    @required this.gradientColor,
    @required this.accentColor,
    @required this.onActionPress,
    @required this.onPostponePress,
  });

  @override
  MultipleActionDialogState createState() {
    return MultipleActionDialogState();
  }
}

class MultipleActionDialogState extends State<MultipleActionDialog> {
  bool _isLoading = false;
  int daysToPostpone = 1;
  DateTime datePicked = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      contentPadding: EdgeInsets.all(0),
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: 290,
              margin: EdgeInsets.fromLTRB(16, 16, 0, 8),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close, size: 28, color: Colors.grey)),
            ),
          ],
        ),
        widget.bodyText != null
            ? Padding(
                padding: EdgeInsets.fromLTRB(8, 20, 8, 0),
                child: Center(
                    child: Text(
                  widget.bodyText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )))
            : Container(),
        Center(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  LastActionDate(widget.accentColor, datePicked, (date) {
                    _setDatePicked(date);
                  })
                ]))),
        FrequencyDays(
            type: 'Posponer',
            initialValue: daysToPostpone,
            color: YellowSecond,
            onChange: (value) {
              _setDaysToPostpone(value);
            }),
        Center(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                ButtonBar(children: <Widget>[_buildPostponeButton(), _buildActionButton()])
              ])),
        )
      ],
    );
  }

  Widget _buildActionButton() {
    return GradientButton(
        shadow: true,
        gradient: widget.gradientColor,
        height: 40,
        width: 120,
        buttonRadius: BorderRadius.all(Radius.circular(8)),
        onPressed: () => widget.onActionPress(datePicked),
        child: Text(widget.action, style: TextStyle(fontSize: 16, color: Colors.white)));
  }

  Widget _buildPostponeButton() {
    return GradientButton(
        shadow: true,
        gradient: YellowGradient,
        height: 40,
        width: 120,
        buttonRadius: BorderRadius.all(Radius.circular(8)),
        onPressed: () => widget.onPostponePress(daysToPostpone),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('POSPONER', style: TextStyle(fontSize: 12, color: Colors.white)),
          Text('+ ${daysToPostpone.toString()} ${daysToPostpone == 1 ? 'día' : 'días'}',
              style: TextStyle(fontSize: 10, color: Colors.white))
        ]));
  }

  _setDatePicked(DateTime datePicked) {
    this.datePicked = datePicked;
  }

  _setDaysToPostpone(int daysToPostpone) {
    setState(() {
      this.daysToPostpone = daysToPostpone;
    });
  }
}
