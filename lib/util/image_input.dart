import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function(File) setImageFile;
  final String imageSource;

  ImageInput(this.setImageFile, this.imageSource);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;
  String _messageImageButton = '  Añadir Imagen';

  _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxHeight: 400.0).then((File image) {
      widget.setImageFile(image);
      setState(() {
        _imageFile = image;
      });
      Navigator.pop(context);
    });
  }

  _openImagePicker(BuildContext context) {
    var _accentColor = Theme.of(context).accentColor;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 150.0,
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Selecciona una imagen',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  FlatButton(
                    textColor: _accentColor,
                    child: Text('Usar Cámara'),
                    onPressed: () {
                      _getImage(context, ImageSource.camera);
                    },
                  ),
                  FlatButton(
                    textColor: _accentColor,
                    child: Text('Usar Galeria'),
                    onPressed: () {
                      _getImage(context, ImageSource.gallery);
                    },
                  )
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    var _buttonColor = Theme.of(context).primaryColor;
    return Column(children: <Widget>[
      SizedBox(height: 5.0),
      _checkImageSource(_imageFile, widget.imageSource),
      OutlineButton(
        borderSide: BorderSide(color: _buttonColor, width: 2.0),
        onPressed: () {
          _openImagePicker(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.camera_alt, color: _buttonColor),
            SizedBox(height: 5.0),
            Text(_messageImageButton, style: TextStyle(color: _buttonColor))
          ],
        ),
      ),
    ]);
  }

  Widget _checkImageSource(File imageFile, String imageSource) {
    Widget imageWidget;
    if (imageFile == null && (imageSource == '' || imageSource == null)) {
      imageWidget = SizedBox(height: 5.0);
    } else {
      var imageHeight = MediaQuery.of(context).size.width - 20.0;
      var imageWidth = MediaQuery.of(context).size.width;

      if (imageFile == null && imageSource != '') {
        imageWidget = Image.network(imageSource,
            fit: BoxFit.cover, height: imageHeight, width: imageWidth, alignment: Alignment.center);
        _messageImageButton = '  Cambiar Imagen';
      } else {
        imageWidget = Image.file(imageFile,
            fit: BoxFit.cover, height: imageHeight, width: imageWidth, alignment: Alignment.center);
      }
    }
    return imageWidget;
  }
}
