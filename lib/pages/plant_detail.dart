import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/components/custom_scroll_color.dart';
import 'package:wetplant/components/delete_dialog.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/model/garden_plant.dart';
import 'package:wetplant/pages/page_manager.dart';
import 'package:wetplant/pages/plant_edit.dart';
import 'package:wetplant/scoped_model/main_model.dart';
import 'package:wetplant/util/plant_list_image.dart';
import 'package:wetplant/util/reminder_info_panel_carousel.dart';

class PlantDetailPage extends StatefulWidget {
  final GardenPlant gardenPlant;

  PlantDetailPage(this.gardenPlant);

  @override
  _PlantDetailPageState createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  bool _waitingAction = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    var imageHeight = orientation == Orientation.portrait ? size.height / 1.8 : size.height * 1.8;
    var imageWidth = size.width;
    return _waitingAction
        ? Scaffold(
            body: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 10.0),
            Text('Eliminando tu plantita')
          ])))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black45),
                title: Text(widget.gardenPlant.plant.name.toUpperCase(),
                    style: TextStyle(color: GreenMain)),
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
                    tag: widget.gardenPlant.plant.id,
                    child: Container(
                        child:
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      PlantListImage(widget.gardenPlant.plant.image, imageHeight, imageWidth,
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                      ReminderInfoPanelCarousel(reminders: widget.gardenPlant.reminders),
                    ])))
              ]),
            ));
  }

  void _select(_MenuChoice _menuChoice, BuildContext context) {
    if (_menuChoice.type == 'delete') {
      openDeleteDialog(context);
    } else if (_menuChoice.type == 'edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantEditPage(gardenPlant: widget.gardenPlant),
        ),
      );
    }
  }

  void openDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
              return DeleteDialog(
                  name: widget.gardenPlant.plant.name.toUpperCase(),
                  onRemove: (context) {
                    Navigator.of(context).pop();
                    try {
                      setState(() {
                        _waitingAction = true;
                      });
                      deletePlant(model);
                    } catch (e) {
                      print(e.toString());
                      Navigator.of(context).pop();
                    }
                  });
            }));
  }

  deletePlant(MainModel model) async {
    await model.deletePlant(widget.gardenPlant.plant.id, widget.gardenPlant.plant.image);
    Navigator.pushReplacement(context,
        MaterialPageRoute<bool>(builder: (BuildContext context) => PageManagerPage(model)));
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
