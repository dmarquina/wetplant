import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wetplant/constants/colors';

class ImageInput extends StatefulWidget {
  final Function(File) onSave;

  ImageInput({@required this.onSave});

  @override
  State<StatefulWidget> createState() {
    return ImageInputState();
  }
}

enum ImageSourceType { Camera, Gallery }

class ImageInputState extends State<ImageInput> {
  ImageSourceType _imageSourceType = ImageSourceType.Camera;

  Future<File> _getImageFromCamera() async {
    var value = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 500.0);
    setState(() {
      _imageSourceType = ImageSourceType.Camera;
    });
    return value;
  }

  Future<File> _getImageFromGallery() async {
    var value = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 500.0);
    setState(() {
      _imageSourceType = ImageSourceType.Gallery;
    });
    return value;
  }

  Widget _getImageContainer(
      double height, double width, Icon icon, ImageSourceType type, dynamic value) {
    return Container(
        height: height,
        width: width,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        decoration: BoxDecoration(
          gradient: GreenGradient,
          image: (value != null && type == _imageSourceType)
              ? DecorationImage(
                  image: FileImage(value),
                  fit: BoxFit.cover,
                )
              : null,
          borderRadius: BorderRadius.all(Radius.circular(60)),
        ),
        child: icon);
  }

  Widget _getCameraContainer(FormFieldState<dynamic> imageForm) {
    return _getImageContainer(
        110,
        110,
        Icon(
          Icons.camera_alt,
          size: 28,
          color: Colors.white,
        ),
        ImageSourceType.Camera,
        imageForm.value);
  }

  Widget _getGalleryContainer(FormFieldState<dynamic> imageForm) {
    return _getImageContainer(
        70,
        70,
        Icon(
          Icons.image,
          size: 20,
          color: Colors.white,
        ),
        ImageSourceType.Gallery,
        imageForm.value);
  }

  Widget _getErrorWidget(bool hasError, String errorText) {
    return hasError
        ? Text(errorText, style: TextStyle(color: Colors.red, fontSize: 12))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      onSaved: (File file) {
        widget.onSave(file);
      },
      validator: (value) {
        return value == null ? 'Selecciona o toma una foto' : null;
      },
      builder: (imageForm) {
        return Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        File image = await _getImageFromGallery();
                        _checkFileCorrectSize(imageForm, image);
                      },
                      child: _getGalleryContainer(imageForm),
                    ),
                    Text('Seleccionar', style: TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            File image = await _getImageFromCamera();
                            _checkFileCorrectSize(imageForm, image);
                          },
                          child: _getCameraContainer(imageForm),
                        ),
                        Text('Capturar', style: TextStyle(color: Colors.black54, fontSize: 16)),
                      ],
                    ),
                    _getErrorWidget(imageForm.hasError, imageForm.errorText)
                  ],
                ))
          ],
        );
      },
    );
  }

  _checkFileCorrectSize(FormFieldState<dynamic> imageForm, File image) {
    if (image.lengthSync() <= 1000000) {
      widget.onSave(image);
      imageForm.setValue(image);
      imageForm.setState(() {});
    } else {
      _openDialogImageSizeExceeded();
    }
  }

  _openDialogImageSizeExceeded() {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
                contentPadding: EdgeInsets.all(0),
                title: Text('ESPERA', style: TextStyle(fontSize: 18.0)),
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
                      child:
                          Text('Esta imagen supera el tamaño de 1MB permitido, selecciona otra')),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('ENTIENDO'),
                      ),
                    ],
                  )
                ]));
  }
}
