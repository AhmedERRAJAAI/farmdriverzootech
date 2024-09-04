import 'dart:async';
import 'dart:convert';

import 'package:farmdriverzootech/core/conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SupplimentatioProvider with ChangeNotifier {
  final List _supplimentations = [
    // FETCHED DATA ...
  ];

  List get supplimentations {
    return [
      ..._supplimentations
    ];
  }

  final List _lastSupplimentations = [
    // FETCHED DATA ...
  ];

  List get lastSupplimentations {
    return [
      ..._lastSupplimentations
    ];
  }

  Future<void> getSupplimentations(lotId) async {
    final url = Uri.parse('${GlobalConf.prodUrl}get-supplimentations-list/?lot=$lotId');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedProducts = json.decode(responseBody) as List;
        _supplimentations.clear();
        for (var item in fetchedProducts) {
          if (item == null) {
            continue;
          }
          _supplimentations.add(item);
        }
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getLastTwoSupplimentations() async {
    final url = Uri.parse('${GlobalConf.prodUrl}get-two-supplimentations-list/');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedProducts = json.decode(responseBody) as List;
        _lastSupplimentations.clear();
        for (var item in fetchedProducts) {
          if (item == null) {
            continue;
          }
          _lastSupplimentations.add(item);
        }
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
