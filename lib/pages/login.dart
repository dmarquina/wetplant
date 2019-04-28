import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wetplant/constants/colors';
import 'package:wetplant/pages/page_manager.dart';
import 'dart:convert';

import 'package:wetplant/pages/watered_plants.dart';
import 'package:wetplant/util/custom_icons_icons.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _confirmPasswordController = TextEditingController(text: '');
  bool _login = true;
  bool _passwordsNotMatched = false;
  bool _isLoading = false;
  String _userId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _isLoading ? Colors.white : GreenMain,
        body: _isLoading
            ? Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10.0,
                ),
                Text('Iniciando sesión')
              ]))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: Icon(CustomIcons.water_amount_large,color: Colors.white,size: 80)),
                  SizedBox(height: 50.0),
                  Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      elevation: 4.0,
                      margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                              padding: EdgeInsets.all(20.0),
                              child: Column(children: <Widget>[

//                                Text('Bienvenid@',
//                                    style: TextStyle(
//                                        fontWeight: FontWeight.w600,
//                                        fontSize: 24.0,
//                                        color: Colors.green)),
//                                SizedBox(height: 10.0),
//                                Divider(),
                                TextFormField(
                                    controller: _emailController,
                                    decoration:
                                        InputDecoration(helperText: 'Correo', counterText: ''),
                                    maxLength: 25,
                                    validator: (String value) {
                                      if (value.isEmpty ||
                                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                              .hasMatch(value)) {
                                        return 'El correo ingresado no cumple el formato ';
                                      }
                                    }),
                                TextField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                        helperText: 'Contraseña',
                                        counterText: '',
                                        errorText: _passwordsNotMatched
                                            ? 'Las contraseñas no coinciden'
                                            : null),
                                    obscureText: true,
                                    maxLength: 20),
                                _login
                                    ? Container()
                                    : TextField(
                                        controller: _confirmPasswordController,
                                        decoration: InputDecoration(
                                            helperText: 'Confirmar contraseña',
                                            counterText: '',
                                            errorText: _passwordsNotMatched
                                                ? 'Las contraseñas no coinciden'
                                                : null),
                                        obscureText: true,
                                        maxLength: 20),
                                SizedBox(height: 10.0),
                                Divider(),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: FlatButton(
                                        child: Text(_login ? 'INGRESAR' : 'CREAR CUENTA',
                                            style: TextStyle(color: Colors.white)),
                                        onPressed: _authenticate,
                                        color: GreenMain))
                              ])))),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Text(_login ? '¿Aún no tienes cuenta? ' : '¿Ya tienes cuenta? ',
                        style: TextStyle(color: Colors.white)),
                    InkWell(
                      onTap: toggleLoginToCreateAccount,
                      child: Text(_login ? 'Regístrate' : 'Inicia Sesión',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ]),
                  SizedBox(height: 30.0),
                  InkWell(
                    onTap: () {},
                    child: Text('Términos y condiciones',
                        style: TextStyle(color: Colors.white, fontSize: 13.0)),
                  ),
                ],
              ));
  }

  toggleLoginToCreateAccount() {
    setState(() {
      _login = !_login;
      _formKey.currentState.reset();
      _emailController.text = '';
      _passwordController.text = '';
      _confirmPasswordController.text = '';
      _passwordsNotMatched = false;
    });
  }

  bool _confirmPassword() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  _authenticate() async {
    if (!_login && !_confirmPassword()) {
      setState(() {
        _passwordsNotMatched = true;
        _isLoading = false;
        if (!_formKey.currentState.validate()) {
          return;
        }
        return;
      });
    } else {
      if (!_formKey.currentState.validate()) {
        setState(() {
          _isLoading = false;
        });
        return;
      } else {
        setState(() {
          _isLoading = true;
        });
        final Map<String, dynamic> authData = {
          'email': _emailController.text,
          'password': _passwordController.text
        };
        Response res;
        if (_login) {
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
        Map<String, dynamic> successInformation = _checkAuthenticate(responseData);
        if (successInformation['success']) {
          _goToMyPlants();
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Ocurrió un error'),
                  content: Text(successInformation['message']),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        }
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> _checkAuthenticate(Map<String, dynamic> responseData) {
    bool hasError = true;
    String message = 'Ocurrió un error';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Autenticación exitosa.';
      _userId = responseData['localId'];
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Este correo no fue encontrado.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Contraseña inválida.';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Este correo ya existe';
    }

    return {'success': !hasError, 'message': message};
  }

  _goToMyPlants() => Navigator.pushReplacement(context, MaterialPageRoute<bool>(
  builder: (BuildContext context) => PageManagerPage(_userId)));
}
