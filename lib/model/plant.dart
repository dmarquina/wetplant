class Plant {
  int _id;
  int _minWateringDays;
  int _maxWateringDays;
  int _daysSinceLastDayWatering;
  String _lastDayWatering;
  String _name;
  String _image;

  Plant(this._id, this._minWateringDays, this._maxWateringDays,
      this._daysSinceLastDayWatering, this._lastDayWatering, this._name, this._image);

  int get id => _id;

  set setId(int value) => _id = value;

  int get minWateringDays => _minWateringDays;

  int get daysSinceLastDayWatering => _daysSinceLastDayWatering;

  set setDaysSinceLastDayWatering(int value) => _daysSinceLastDayWatering = value;

  int get maxWateringDays => _maxWateringDays;

  String get lastDayWatering => _lastDayWatering;

  set setLastDayWatering(String lastDayWatering) => _lastDayWatering = lastDayWatering;

  set setMaxWateringDays(int value) => _maxWateringDays = value;

  set setMinWateringDays(int value) => _minWateringDays = value;

  String get name => _name;

  set setName(String value) => _name = value;

  String get image => _image;

  set setImage(String value) => _image = value;
}
