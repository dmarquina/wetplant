import 'package:flutter/material.dart';
import 'package:wetplant/constants/colors';

class PlantNameBox extends StatelessWidget {
  final String plantName;

  PlantNameBox(this.plantName);

  @override
  Widget build(BuildContext context) {
    Color timeBasedColor = BlueMain;
    Color _kKeyUmbraOpacity = timeBasedColor.withAlpha(51);
    Color _kKeyPenumbraOpacity = timeBasedColor.withAlpha(36);
    Color _kAmbientShadowOpacity = timeBasedColor.withAlpha(31);
    return Container(
        height: 40,
        alignment: Alignment(-1.0, 0.0),
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          gradient: GreenGradient,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
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
                color: _kAmbientShadowOpacity)
          ],
        ),
        child: Text(plantName.toUpperCase(), style: TextStyle(fontSize: 16, color: Colors.white)));
  }
}
