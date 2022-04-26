import 'dart:convert';
import 'package:chat/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';

class AuthService with ChangeNotifier {
  UsuarioModel? usuario;
  bool _autenticando = false;
  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  static Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return (token == null) ? 'No-token' : token;
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    final data = {'email': email, 'password': password};
    final resp = await http.post(
        Uri.http(Environment.host, '${Environment.path}/login'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});
    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    autenticando = true;

    final data = {'nombre': nombre, 'email': email, 'password': password};
    final resp = await http.post(
        Uri.http(Environment.host, '${Environment.path}/login/new'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});
    autenticando = false;
    if (resp.statusCode == 200) {
      final registerResponse = loginResponseFromJson(resp.body);
      usuario = registerResponse.usuario;
      await _guardarToken(registerResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final resp = await http.get(
        Uri.http(Environment.host, '${Environment.path}/login/renew'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': (token == null) ? '' : token
        });
    autenticando = false;
    if (resp.statusCode == 200) {
      final registerResponse = loginResponseFromJson(resp.body);
      usuario = registerResponse.usuario;
      await _guardarToken(registerResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
