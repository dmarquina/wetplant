import 'package:flutter/material.dart';
import 'package:wetplant/constants/colors';

class DeleteDialog extends StatelessWidget {
  final Function(BuildContext context) onRemove;
  final String name;

  DeleteDialog({this.onRemove, this.name});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      title: Text('¿Deseas eliminar ${name.trim()}?'),
      children: <Widget>[
        ButtonBar(
          children: <Widget>[
            FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('NO')),
            FlatButton(
                color: RedMain,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                onPressed: () {
                  onRemove(context);
                },
                child: Text('ELIMINAR', style: TextStyle(color: Colors.white)))
          ],
        )
      ],
    );
  }
}
