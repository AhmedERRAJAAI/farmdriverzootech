import 'dart:async';
import 'dart:convert';

import 'package:farmdriverzootech/core/conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InitProvider with ChangeNotifier {
  List<SliderItem> _slides = [
    // FETCHED DATA ...
  ];

  List<SliderItem> get slidesData {
    return [
      ..._slides
    ];
  }

  Future<void> fetchSliderData() async {
    final url = Uri.parse('${GlobalConf.prodUrl}dash-slider/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };

    try {
      slidesData.clear();
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedProducts = json.decode(responseBody) as List;
        final List<SliderItem> extractedData = [];
        for (var item in fetchedProducts) {
          extractedData.add(
            SliderItem(
              siteId: item['site_id'],
              siteName: item['placeName'],
              ageMoy: item['ageMoy'],
              effectifPresent: item['effectifPresent'],
              lastUpdate: item['lastUpdate'],
              prodJour: item['prodJour'],
              mortJour: item['mortJour'],
              siteIsGood: item['siteIsGood'],
              statusMsg: item['statusMsg'],
            ),
          );
        }
        _slides = extractedData;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  List<Lot> _lots = [
    // FETCHED DATA ...
  ];

  List<Lot> get lots {
    return [
      ..._lots
    ];
  }

  Future<void> getLotList(site, getAll) async {
    final url = Uri.parse('${GlobalConf.prodUrl}get-lots-by-site/?site_id=$site&get_all=$getAll');
    final prefs = await SharedPreferences.getInstance();
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
        _lots.clear();
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedData = json.decode(responseBody) as List;
        final List<Lot> extractedData = [];
        for (var item in fetchedData) {
          extractedData.add(
            Lot(
              status: item["status"],
              batiment: item['batiment'],
              siteId: item['site_id'],
              code: item["code"],
              lotId: item["id"],
            ),
          );
        }
        _lots = extractedData;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("ERROR  DURING FETCHING");
    }
  }

  List _weather = [];

  List get weather {
    return [
      ..._weather
    ];
  }

  Future<void> getWeather() async {
    final url = Uri.parse('${GlobalConf.prodUrl}get-weather/');

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
        _weather = json.decode(responseBody) as List;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendObservation(data) async {
    final url = Uri.parse('${GlobalConf.prodUrl}add-observ/');

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
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        getObservs();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  List _observs = [];

  List get observs {
    return [
      ..._observs
    ];
  }

  Future<void> getObservs() async {
    final url = Uri.parse('${GlobalConf.prodUrl}get-dash-observations/');

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
        _observs = json.decode(responseBody) as List;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

//
// DASH CHARTS --------------------------------------------
//

  List<ProdDashChart> _prodChart = [];
  List<ProdDashChart> get prodChart {
    return [
      ..._prodChart
    ];
  }

  List<MortDashChart> _mortChart = [];
  List<MortDashChart> get mortChart {
    return [
      ..._mortChart
    ];
  }

  List<ApoDashChart> _apoChart = [];
  List<ApoDashChart> get apoChart {
    return [
      ..._apoChart
    ];
  }

  List<AltDashChart> _altChart = [];
  List<AltDashChart> get altChart {
    return [
      ..._altChart
    ];
  }

  Future<void> getDashCharts(time, site) async {
    final url = Uri.parse('${GlobalConf.prodUrl}dash-charts/?time=$time&place=$site');

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
        final List<ProdDashChart> extProdData = [];
        final List<MortDashChart> extMortData = [];
        final List<ApoDashChart> extApoData = [];
        final List<AltDashChart> extTempData = [];
        for (var item in fetchedProducts) {
          extProdData.add(
            ProdDashChart(date: DateTime.parse(item["date"]), prod: double.parse("${item["production"] ?? "0"}")),
          );
          extMortData.add(
            MortDashChart(date: DateTime.parse(item["date"]), mort: double.parse("${item["mort"] ?? "0"}")),
          );
          extApoData.add(
            ApoDashChart(date: DateTime.parse(item["date"]), apo: double.parse("${item["apo"] ?? "0"}")),
          );
          extTempData.add(
            AltDashChart(date: DateTime.parse(item["date"]), alt: double.parse("${item["alt"] ?? "0"}")),
          );
        }
        _prodChart = extProdData;
        _mortChart = extMortData;
        _apoChart = extApoData;
        _altChart = extTempData;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}

class ProdDashChart {
  final DateTime date;
  final double prod;
  ProdDashChart({
    required this.date,
    required this.prod,
  });
}

class MortDashChart {
  final DateTime date;
  final double mort;
  MortDashChart({
    required this.date,
    required this.mort,
  });
}

class ApoDashChart {
  final DateTime date;
  final double apo;
  ApoDashChart({
    required this.date,
    required this.apo,
  });
}

class AltDashChart {
  final DateTime date;
  final double alt;
  AltDashChart({
    required this.date,
    required this.alt,
  });
}

class Lot {
  final String batiment;
  final int siteId;
  final int lotId;
  final String code;
  final int status; //1: active, 2: being reformed, 3:archived
  Lot({
    required this.status,
    required this.batiment,
    required this.siteId,
    required this.lotId,
    required this.code,
  });
}

class SliderItem {
  final int siteId;
  final String siteName;
  final String? lastUpdate;
  final int? effectifPresent;
  final int? ageMoy;
  final int? prodJour;
  final int? mortJour;
  final bool? siteIsGood;
  final String? statusMsg;

  SliderItem({
    required this.siteId,
    required this.siteName,
    this.ageMoy,
    this.mortJour,
    this.effectifPresent,
    this.lastUpdate,
    this.siteIsGood,
    this.statusMsg,
    this.prodJour,
  });
}
