import 'package:scoped_model/scoped_model.dart';
import 'package:wetplant/scoped_model/plant_scoped_model.dart';
import 'package:wetplant/scoped_model/user_scoped_model.dart';

class MainModel extends Model with UserScopedModel, PlantScopedModel {}
