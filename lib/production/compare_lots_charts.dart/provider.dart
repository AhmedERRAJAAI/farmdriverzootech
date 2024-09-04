import 'dart:async';
import 'dart:convert';

import 'package:farmdriverzootech/core/conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../charts/blue_print.dart';

class ComparaisionProvider with ChangeNotifier {
  final List _comparedCharts = [];

  List get comparedCharts {
    return [
      ..._comparedCharts
    ];
  }

  Future<void> getLotsComparaisionCharts(lots, courbe) async {
    final url = Uri.parse('${GlobalConf.prodUrl}compare-multi-charts/?lots=$lots&courbe=$courbe');
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
        _comparedCharts.clear();
        final responseBody = utf8.decode(response.bodyBytes);
        List gotData = json.decode(responseBody) as List;

        switch (courbe) {
          case 0:
            for (var element in gotData) {
              _comparedCharts.add(prodChartFiller(element)); //PROD CHART FILLER
            }
            break;
          case 1:
            for (var element in gotData) {
              _comparedCharts.add(mortChartFiller(element)); //MORT CHART FILLER
            }
            break;
          case 2:
            for (var element in gotData) {
              _comparedCharts.add(consoChartFiller(element)); //CONSO CHART FILLER
            }
            break;
          case 3:
            for (var element in gotData) {
              _comparedCharts.add(pvHomogChartFiller(element)); //CONSO CHART FILLER
            }
            break;
          case 4:
            for (var element in gotData) {
              _comparedCharts.add(massOeufChartFiller(element)); //CONSO CHART FILLER
            }
            break;
          default:
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

// PRODUCTION CHART FILLER
Map prodChartFiller(gotData) {
  final List<ProdChartData> reel = [];
  final List<GprodChartData> guide = [];
  int dataLength = gotData["ponte"].length;
  for (int i = 0; i < dataLength; i++) {
    reel.add(
      ProdChartData(
        age: gotData["ponte"][i]["age"],
        ponte: double.parse("${gotData["ponte"][i]["ponte"]}"),
        pmo: double.parse("${gotData["pmo"][i]["pmo"]}"),
        noppd: double.parse("${gotData["noppd_cuml"][i]["noppd_cuml"]}"),
        blancs: double.parse("${gotData["blancs"][i]["blanc"]}"),
        declassed: double.parse("${gotData["declass"][i]["declasse"]}"),
      ),
    );
  }
  for (var item in gotData["ages"]) {
    guide.add(GprodChartData(
      age: item["age"],
      gPonte: item["g_ponte"],
      gPmo: item["g_pmo"],
      gNoppd: item["g_nopppcuml"],
    ));
  }
  return {
    "reel": reel,
    "guide": guide,
    "title": gotData["lot"]
  };
}

// MORTALITÉ CHART FILLER
Map mortChartFiller(gotData) {
  final List<MortChartData> reel = [];
  final List<GmortChartData> guide = [];
  int dataLength = gotData["mort_sem"].length;
  for (int i = 0; i < dataLength; i++) {
    reel.add(
      MortChartData(
        age: gotData["mort_sem"][i]["age"], mortSem: gotData["mort_sem"][i]["mort_sem"], mortCuml: gotData["mort_cuml"][i]["mort_sem"], // ! even that the name is dupliacted the data is correct
      ),
    );
  }
  for (var item in gotData["ages"]) {
    guide.add(GmortChartData(
      age: item["age"],
      gMortSem: item["g_mort"],
      gMortCuml: item["g_mortCuml"],
      bar1: 0.05,
      bar2: 0.1,
      bar3: 0.15,
    ));
  }
  return {
    "reel": reel,
    "guide": guide,
    "title": gotData["lot"]
  };
}

// CONSOMMATION CHART FILLER
Map consoChartFiller(gotData) {
  final List<ConsoChartData> reel = [];
  final List<GconsoChartData> guide = [];
  int dataLength = gotData["aps"].length;
  for (int i = 0; i < dataLength; i++) {
    reel.add(
      ConsoChartData(
        age: gotData["aps"][i]["age"],
        aps: double.parse("${gotData["aps"][i]["aps"]}"),
        apsCuml: double.parse("${gotData["aps_cuml"][i]["aps_cuml"]}"),
        eps: double.parse("${gotData["eps"][i]["eps"]}"),
        ratio: double.parse("${gotData["ratio"][i]["ratio"]}"),
      ),
    );
  }
  for (var item in gotData["ages"]) {
    guide.add(GconsoChartData(age: item["age"], gAps: item["g_aps"], gApsCuml: item["g_apscuml"]));
  }
  return {
    "reel": reel,
    "guide": guide,
    "title": gotData["lot"]
  };
}

// CONSOMMATION CHART FILLER
Map pvHomogChartFiller(gotData) {
  final List<PvChartData> reel = [];
  final List<GpvChartData> guide = [];
  int dataLength = gotData["pv"].length;
  for (int i = 0; i < dataLength; i++) {
    reel.add(
      PvChartData(
        age: gotData["pv"][i]["age"],
        poids: gotData["pv"][i]["pv"],
        homog: gotData["pv"][i]["homog"],
      ),
    );
  }
  for (var item in gotData["ages"]) {
    guide.add(GpvChartData(age: item["age"], pv: item["g_pv"]));
  }
  return {
    "reel": reel,
    "guide": guide,
    "title": gotData["lot"]
  };
}

// CONSOMMATION CHART FILLER
Map massOeufChartFiller(gotData) {
  final List<MasseChartData> reel = [];
  final List<GmasseChartData> guide = [];
  int dataLength = gotData["massSem"].length;
  for (int i = 0; i < dataLength; i++) {
    reel.add(
      MasseChartData(
        age: gotData["massSem"][i]["age"],
        massSem: double.parse("${gotData["massSem"][i]["massSem"]}"),
        massCuml: double.parse("${gotData["massCuml"][i]["massCuml"]}"),
      ),
    );
  }
  for (var item in gotData["ages"]) {
    guide.add(GmasseChartData(
      age: item["age"],
      gMassCuml: item["g_masse_cuml"],
      gMassSem: item["g_masse_sem"],
    ));
  }
  return {
    "reel": reel,
    "guide": guide,
    "title": gotData["lot"]
  };
}
