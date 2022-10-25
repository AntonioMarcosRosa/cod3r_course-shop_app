import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  Future<void> _authentication(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts$urlFragment?key=';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
  }

  Future<void> singUp(String email, String password) async {
    await _authentication(email, password, 'signUp');
  }

  Future<void> singIn(String email, String password) async {
    await _authentication(email, password, 'signInWithPassword');
  }
}
