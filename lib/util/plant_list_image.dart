import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlantListImage extends StatelessWidget {
  final String plantImage;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  PlantListImage(this.plantImage, this.height, this.width,
      {this.borderRadius = const BorderRadius.only(topLeft: Radius.circular(5))});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(
                image: CachedNetworkImageProvider(plantImage ?? ''), fit: BoxFit.cover),
            borderRadius: borderRadius));
  }
}
