import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/conf.dart';

class AuthProvider with ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;
  Map? _initData;

  bool get isAuth {
    return _accessToken != null;
  }

  Map get initData {
    return _initData ?? {};
  }

  int? _userId;
  int? get getUserId {
    return _userId;
  }

// login
  Future<void> login(String username, String password) async {
    final url = Uri.parse('${GlobalConf.prodUrl}token');
    final headers = {
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(
          {
            'username': username,
            'password': password
          },
        ),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _accessToken = json.decode(response.body)['access'];
        _refreshToken = json.decode(response.body)['refresh'];

        Map<String, dynamic> userDecodedData = Jwt.parseJwt(_accessToken ?? '');
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _accessToken,
          'refresh': _refreshToken,
          'user_id': userDecodedData["user_id"],
          'eleveur': userDecodedData["eleveur"],
          'first_name': userDecodedData['first_name'],
          'last_name': userDecodedData['last_name'],
          'funcs_access': userDecodedData["funcs_access"],
          'pages_access_data': userDecodedData["pages_access_data"],
          'role': userDecodedData["role"],
          'show_pouss': userDecodedData["show_pouss"],
          'show_prod': userDecodedData["show_prod"],
          'expiry_date': userDecodedData["exp"],
        });
        prefs.setString('userdata', userData);
        final decodedData = jsonDecode(prefs.getString('userdata') ?? '');
        _initData = {
          "f_name": decodedData['first_name'],
          "l_name": decodedData["last_name"],
          "eleveur_name": decodedData["eleveur"]
        };
        _userId = userDecodedData["user_id"];
        notifyListeners();
      } else {
        if (response.statusCode == 401) {
          logout();
          throw Exception("Identifiant ou mot de passe est incorrect");
        }
      }
    } catch (e) {
      rethrow;
    }
  }

// refresh token
  Future<void> refresh(String token) async {
    logout(); //clear shared prefs
    final url = Uri.parse('${GlobalConf.prodUrl}token/refresh');
    final headers = {
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(
          {
            'refresh': token
          },
        ),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _accessToken = json.decode(response.body)['access'];
        _refreshToken = json.decode(response.body)['refresh'];

        Map<String, dynamic> userDecodedData = Jwt.parseJwt(_accessToken ?? '');
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _accessToken,
          'refresh': _refreshToken,
          'user_id': userDecodedData["user_id"],
          'eleveur': userDecodedData["eleveur"],
          'first_name': userDecodedData['first_name'],
          'last_name': userDecodedData['last_name'],
          'funcs_access': userDecodedData["funcs_access"],
          'pages_access_data': userDecodedData["pages_access_data"],
          'role': userDecodedData["role"],
          'show_pouss': userDecodedData["show_pouss"],
          'show_prod': userDecodedData["show_prod"],
          'expiry_date': userDecodedData["exp"],
        });
        prefs.setString('userdata', userData);
        final decodedData = jsonDecode(prefs.getString('userdata') ?? '');
        _initData = {
          "f_name": decodedData['first_name'],
          "l_name": decodedData["last_name"],
          "eleveur_name": decodedData["eleveur"]
        };
        _userId = userDecodedData["user_id"];
        notifyListeners();
      } else {
        if (response.statusCode == 401) {
          logout();
          throw Exception("Identifiant ou mot de passe est incorrect");
        }
      }
    } catch (e) {
      rethrow;
    }
  }

// try auto loggin
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      logout();
      throw Exception(401);
    }
    final decodedData = jsonDecode(prefs.getString('userdata') ?? '');
    notifyListeners();
    try {
      await refresh(decodedData['refresh'] ?? "");
    } catch (e) {
      await logout();
      throw Exception(401);
    }
  }

  Future<bool> tryAutoLoginBoolReturn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return false;
    }
    final decodedData = jsonDecode(prefs.getString('userdata') ?? '');
    try {
      await refresh(decodedData['refresh']);
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }

// clears local storage
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
}
