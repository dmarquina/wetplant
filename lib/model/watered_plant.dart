import 'package:wetplant/model/plant.dart';

class WateredPlant {
  int _id;
  int _minWateringDays;
  int _maxWateringDays;
  int _daysSinceLastDayWatering;
  String _lastDayWatering;
  Plant plant;

  WateredPlant(this._id, this._minWateringDays, this._maxWateringDays,
      this._daysSinceLastDayWatering, this._lastDayWatering, this.plant);

  int get id => _id;

  set setId(int value) => _id = value;

  int get minWateringDays => _minWateringDays;

  int get daysSinceLastDayWatering => _daysSinceLastDayWatering;

  set setDaysSinceLastDayWatering(int value) => _daysSinceLastDayWatering = value;

  int get maxWateringDays => _maxWateringDays;

  String get lastDayWatering => _lastDayWatering;

  set setLastDayWatering(String lastDayWatering) {
    _lastDayWatering = lastDayWatering;
  }

  set setMaxWateringDays(int value) => _maxWateringDays = value;

  set setMinWateringDays(int value) => _minWateringDays = value;
}
