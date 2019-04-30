import 'package:flutter/material.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/util/custom_icons_icons.dart';

class PlantCard extends StatelessWidget {
  final int plantId;
  final String plantName;
  final String plantImage;
  final int minDays;
  final int actualDays;

  PlantCard(this.plantId, this.plantName, this.plantImage, this.minDays, this.actualDays);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: _declarePlantCardDecoration(),
        child: Column(children: <Widget>[
          Row(children: <Widget>[_buildPlantImage(), _buildPlantInfo()]),
          _buildPlantNameBox()
        ]));
  }

  BoxDecoration _declarePlantCardDecoration() {
    return BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [
      BoxShadow(
        color: Colors.grey[400],
        offset: Offset(0.0, 1.5),
        blurRadius: 1.5,
      ),
    ]);
  }

  Widget _buildPlantImage() {
    return Container(
        height: 130,
        width: 130,
        decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(image: NetworkImage(plantImage), fit: BoxFit.cover),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5))));
  }

  Widget _buildPlantInfo() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      _buildWaterPlantInfo()
//        , _buildFertilizePlantInfo()
    ]);
  }

  Widget _buildWaterPlantInfo() {
    return Row(
      children: <Widget>[
        Container(child: Icon(CustomIcons.water_amount_small, color: ReminderBlueMain, size: 60)),
        Icon(Icons.autorenew, color: Colors.black54),
        Text('$minDays d', style: TextStyle(color: Colors.black54)),
        SizedBox(width: 20.0),
        Icon(Icons.access_time, color: Colors.black54),
        Text('$actualDays d', style: TextStyle(color: Colors.black54))
      ],
    );
  }

  Widget _buildFertilizePlantInfo() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Icon(Icons.flash_on, color: BrownMain, size: 40)),
      Icon(Icons.autorenew),
      Text('60 d'),
      SizedBox(width: 20.0),
      Icon(Icons.access_time),
      Text('35 d')
    ]);
  }

  Widget _buildPlantNameBox() {
    Color timeBasedColor = BlueMain;
    Color _kKeyUmbraOpacity = timeBasedColor.withAlpha(51);
    Color _kKeyPenumbraOpacity = timeBasedColor.withAlpha(36);
    Color _kAmbientShadowOpacity = timeBasedColor.withAlpha(31);
    return Container(
        height: 50,
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
