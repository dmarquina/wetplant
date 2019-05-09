import 'package:flutter/material.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/util/custom_icons_icons.dart';

class NoFlowersToWater extends StatelessWidget {
  final bool hasCompleted;
  final bool hasNoFlowers;

  NoFlowersToWater({this.hasCompleted, this.hasNoFlowers});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(
            _getIcon(),
            color: _getColor(),
            size: 70,
          ),
          Container(
              padding: EdgeInsets.only(top: 28),
              child: Text(
                _getText(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.3)),
              )),
          SizedBox(height: 35.0),
          hasNoFlowers ? _buildArrowToNewPlant() : Container()
        ]));
  }

  IconData _getIcon() {
    if (hasNoFlowers) {
      return CustomIcons.emo_squint;
    }
    return CustomIcons.emo_sunglasses;
  }

  String _getText() {
    if (hasNoFlowers) {
      return 'Agrega una planta\npara iniciar tu nueva aventura';
    }
    return 'Todas tus plantas han sido atendidas';
  }

  Color _getColor() {
    if (hasNoFlowers) {
      return YellowMain;
    }

    return BlueMain;
  }

  Widget _buildArrowToNewPlant() {
    return Icon(Icons.arrow_downward, size: 50.0, color: Color.fromRGBO(0, 0, 0, 0.3));
  }
}
