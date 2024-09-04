import 'dart:async';
import 'dart:convert';

import 'package:farmdriverzootech/core/conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataEntryProvider with ChangeNotifier {
  static const URL = GlobalConf.prodUrl;
  Map _nextSend = {};

  Map get nextData {
    return _nextSend;
  }

  Future<void> getNextSend(lotId) async {
    final url = Uri.parse('${URL}get-next-send/?lot=$lotId');

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
        final fetchedData = json.decode(responseBody) as Map;
        _nextSend = fetchedData;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Map _prefrilledData = {};
  Map get prefilledData {
    return _prefrilledData;
  }

  Future<void> getPrefilled(repId) async {
    final url = Uri.parse('${URL}get-prefilled-data/?id=$repId');

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
        _prefrilledData.clear();
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedData = json.decode(responseBody) as Map;
        _prefrilledData = fetchedData;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("ERROR  DURING FETCHING");
    }
  }

  List<Site> _sites = [];
  List<Site> get sites {
    return _sites;
  }

  Future<void> getSites() async {
    final url = Uri.parse('${URL}get-sites-selects-options/');

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
        final List<Site> extractedData = [];
        for (var item in fetchedProducts) {
          extractedData.add(
            Site(
              name: item["site_name"],
              id: item["site_id"],
            ),
          );
        }
        _nextSend.clear();
        _sites = extractedData;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendProdReport(data) async {
    final url = Uri.parse('${URL}add-report-prod/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final body = json.encode(data);
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _nextSend.clear();
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProdReport(data) async {
    final url = Uri.parse('${URL}update-report-prod/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final body = json.encode(data);
    try {
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _nextSend.clear();
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

// GET LISTS OR REPORTS
  List _reports = [];
  List get reports {
    return _reports;
  }

  Future<void> getLotReportsList(lotId, count) async {
    final url = Uri.parse('${URL}reports-list/?lotId=$lotId&count=$count');

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
        final fetchedData = json.decode(responseBody) as List;

        _reports = fetchedData;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}

class Site {
  final String name;
  final int id;

  Site({required this.name, required this.id});
}
