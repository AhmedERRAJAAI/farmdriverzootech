import 'dart:async';
import 'dart:convert';

import 'package:farmdriverzootech/core/conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsProvider with ChangeNotifier {
  Map _bilanData = {};

  Map get bilanData {
    return _bilanData;
  }

  Future<void> getPartialBilan(lotId) async {
    final url = Uri.parse('${GlobalConf.prodUrl}partial-bilan/?lotId=$lotId');
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
        _bilanData.clear();
        final responseBody = utf8.decode(response.bodyBytes);
        _bilanData = json.decode(responseBody) as Map;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("ERROR GETTING BILAN PARTIEL");
    }
  }
}
