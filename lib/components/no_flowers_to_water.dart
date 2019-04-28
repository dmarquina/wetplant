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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            _buildArrowToNewPlant()
          ],
        ));
  }

  IconData _getIcon() {
    if (hasCompleted) {
      return CustomIcons.emo_thumbsup;
    }

    if (hasNoFlowers) {
      return CustomIcons.emo_squint;
    }

    return CustomIcons.emo_grin;
  }

  String _getText() {
    if (hasCompleted) {
      return 'Todas tus plantas han sido atendidas';
    }

    if (hasNoFlowers) {
      return 'Agrega una planta\npara iniciar tu nueva aventura';
    }

    return 'Ninguna planta necesita atención hoy';
  }

  Color _getColor() {
    if (hasCompleted) {
      return BlueMain;
    }

    if (hasNoFlowers) {
      return YellowMain;
    }

    return GreenMain;
  }

  Widget _buildArrowToNewPlant() {
    return hasNoFlowers && !hasCompleted
        ? Container(
            padding: EdgeInsets.only(top: 20),
            child: Icon(Icons.arrow_downward, color: YellowMain, size: 70))
        : Container();
  }
}
