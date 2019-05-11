import 'package:flutter/material.dart';
import 'package:wetplant/constants/colors';

class FrequencyDaysPure extends StatelessWidget {
  final Function(int) onIncrease;
  final Function(int) onDecrease;
  final int value;
  final String type;
  final Color color;

  FrequencyDaysPure(
      {@required this.onIncrease,
      @required this.onDecrease,
      @required this.value,
      this.type = '',
      this.color = BlueMain});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(top: 16),
            child: Column(
              children: <Widget>[
                Text('$type', style: TextStyle(color: Colors.black54, fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      alignment: Alignment(0, 0),
                      iconSize: 44,
                      color: Colors.black26,
                      onPressed: () {
                        if (value - 1 >= 1) {
                          onDecrease(value - 1);
                        }
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Text(
                        value.toString(),
                        style: TextStyle(fontSize: 40, color: color),
                      ),
                    ),
                    IconButton(
                      alignment: Alignment(0, 0),
                      iconSize: 44,
                      color: Colors.black26,
                      onPressed: () {
                        onDecrease(value + 1);
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                      ),
                    )
                  ],
                ),
                Text('${value == 1 ? 'día' : 'días'} aprox.',
                    style: TextStyle(color: Colors.black54, fontSize: 16)),
              ],
            )));
  }
}

class FrequencyDays extends StatelessWidget {
  final Function(int) onChange;
  final int initialValue;
  final Color color;
  String type;

  FrequencyDays({@required this.onChange, this.initialValue, this.type, this.color = BlueMain});

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: initialValue,
      builder: (frequencyFrom) {
        return FrequencyDaysPure(
          value: frequencyFrom.value,
          color: color,
          onDecrease: (value) {
            if (onChange != null) {
              onChange(value);
            }
            frequencyFrom.setValue(value);
            frequencyFrom.setState(() {});
          },
          onIncrease: (value) {
            if (onChange != null) {
              onChange(value);
            }
            frequencyFrom.setValue(value);
            frequencyFrom.setState(() {});
          },
          type: '$type',
        );
      },
    );
  }
}
