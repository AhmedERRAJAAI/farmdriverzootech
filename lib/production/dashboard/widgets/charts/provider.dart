import 'dart:async';
import 'dart:convert';

import 'package:farmdriverzootech/core/conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashChartProvider with ChangeNotifier {
  final List<ChartData> _pieAgeChartData = [
    // FETCHED DATA ...
  ];

  List<ChartData> get pieAgeChartData {
    return [
      ..._pieAgeChartData
    ];
  }

  Future<void> getAgePieChartData(siteId) async {
    final url = siteId != 0 ? Uri.parse('${GlobalConf.prodUrl}dash-ages-chart/?site_id=$siteId') : Uri.parse('${GlobalConf.prodUrl}dash-ages-chart/');
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
        final data = json.decode(responseBody) as Map;
        _pieAgeChartData.clear();
        for (var item in data["data"]) {
          _pieAgeChartData.add(ChartData(x: item["name"], y: item["effectif"], size: "${item["effectif"] / data["effectif_total"] * 100 + 80}"));
        }
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

class ChartData {
  ChartData({required this.x, required this.y, required this.size});
  final String x;
  final int y;
  final String size;
}
