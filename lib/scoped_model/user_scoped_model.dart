import 'package:scoped_model/scoped_model.dart';

mixin UserScopedModel on Model {
  String _ownerId;

  String get ownerId => _ownerId;

  setOwnerId(String ownerId) => _ownerId = ownerId;
}
