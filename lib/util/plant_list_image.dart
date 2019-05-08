import 'package:flutter/material.dart';

class PlantListImage extends StatelessWidget {
  final String plantImage;
  final double height;
  final double width;

  PlantListImage(this.plantImage,this.height,this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(image: NetworkImage(plantImage ?? ''), fit: BoxFit.cover),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5))));
  }
}

