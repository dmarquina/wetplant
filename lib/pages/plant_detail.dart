import 'package:flutter/material.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/delete_dialog.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/util/plant_list_image.dart';
import 'package:wetplant/util/reminder_info_panel_carousel.dart';

class PlantDetailPage extends StatelessWidget {
  final GardenPlant gardenPlant;

  PlantDetailPage(this.gardenPlant);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    var imageHeight = orientation == Orientation.portrait ? size.height / 1.8 : size.height * 1.8;
    var imageWidth = size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black45),
            title: Text(gardenPlant.plant.name.toUpperCase(),
                style: TextStyle(fontSize: 16, color: GreenMain)),
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0.0,
            actions: <Widget>[
              PopupMenuButton<_MenuChoice>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (_menuChoice) {
                    _select(_menuChoice, context);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<_MenuChoice>(
                        value: _menuChoices[0],
                        child: Text(_menuChoices[0].title),
                      ),
                      PopupMenuItem<_MenuChoice>(
                        value: _menuChoices[1],
                        child: Text(_menuChoices[1].title),
                      )
                    ];
                  })
            ]),
        body: CustomScrollColor(
          child: ListView(children: <Widget>[
            Hero(
                tag: gardenPlant.plant.id,
                child: Container(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  PlantListImage(gardenPlant.plant.image, imageHeight, imageWidth,
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                  ReminderInfoPanelCarousel(reminders: gardenPlant.reminders),
                ])))
          ]),
        ));
  }

  void _select(_MenuChoice _menuChoice, BuildContext context) {
    if (_menuChoice.type == 'delete') {
      openDeleteDialog(context);
    } else if (_menuChoice.type == 'edit') {
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) => EditFlower(flower: widget.flower),
//        ),
//      );
    }
  }

  void openDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => DeleteDialog(
              name: gardenPlant.plant.name,
              onRemove: (context) {
                try {
                  print(gardenPlant.plant.id);
//              database.deleteFlower(widget.flower.key);
                } catch (e) {
                  print(e.toString());
                  Navigator.of(context).pop();
                }
                Navigator.pop(context);
              },
            ));
  }
}

class _MenuChoice {
  final String title;
  final String type;

  const _MenuChoice({this.title, this.type});
}

const List<_MenuChoice> _menuChoices = [
  _MenuChoice(title: 'Editar', type: 'edit'),
  _MenuChoice(title: 'Eliminar', type: 'delete'),
];
