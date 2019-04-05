class Plant {
  int _id;
  String _name;
  String _image;


  Plant(this._id, this._name, this._image);

  int get id => _id;

  set setId(int value) => _id = value;

  String get name => _name;

  String get image => _image;

  set setImage(String value) => _image = value;

  set setName(String value) => _name = value;
}
