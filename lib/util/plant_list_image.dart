import 'package:flutter/material.dart';

class PlantListImage extends StatelessWidget {
  final String plantImage;


  PlantListImage(this.plantImage);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(image: NetworkImage(plantImage ?? ''), fit: BoxFit.cover),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5))));
  }
}

