import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wetplant/model/User.dart';

mixin UserScopedModel on Model {
  User authenticatedUser;
  PublishSubject<bool> _userSubject = PublishSubject();

  Future<Map<String, dynamic>> authenticate(bool login, Map<String, dynamic> authData) async {
    Response res;
    if (login) {
      res = await post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDi5Vxp1H07xK9-9m00aW3gpE-UTHamsZw',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      res = await post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDi5Vxp1H07xK9-9m00aW3gpE-UTHamsZw',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }
    final Map<String, dynamic> responseData = json.decode(res.body);
    return await _checkAuthenticate(responseData, authData['email']);
  }

  Future<Map<String, dynamic>> _checkAuthenticate(
      Map<String, dynamic> responseData, String email) async {
    bool hasError = true;
    String message = 'Ocurrió un error';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Autenticación exitosa.';
      authenticatedUser =
          User(id: responseData['localId'], email: email, token: responseData['idToken']);
      _userSubject.add(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Este correo no fue encontrado.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Contraseña inválida.';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Este correo ya existe';
    }

    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
//    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
//      final DateTime now = DateTime.now();
//      final parsedExpiredTime = DateTime.parse(expiryTimeString);
//      if (parsedExpiredTime.isBefore(now)) {
//        authenticatedUser = null;
//        notifyListeners();
//        return;
//      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
//      final int tokenLifespan = parsedExpiredTime.difference(now).inSeconds;
      authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      notifyListeners();
    }
  }

  void logout() async {
    authenticatedUser = null;
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('token'));
    print(prefs.get('userEmail'));
    print(prefs.get('userId'));
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

}
