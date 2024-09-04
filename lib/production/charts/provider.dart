import 'dart:async';
import 'dart:convert';

import 'package:farmdriverzootech/core/conf.dart';
import 'package:farmdriverzootech/production/charts/blue_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChartsTableProvider with ChangeNotifier {
//  PROD CHART ========================
  List<ProdChartData> _prodData = [];

  List<ProdChartData> get prodData {
    return [
      ..._prodData
    ];
  }

  List<GprodChartData> _guideProdData = [];
  List<GprodChartData> get guideProdData {
    return [
      ..._guideProdData
    ];
  }

// END PROD CHART ========================
//
// START CONSO CHART  ========================
  List<ConsoChartData> _consoData = [];

  List<ConsoChartData> get consoData {
    return [
      ..._consoData
    ];
  }

  List<GconsoChartData> _guideConsoData = [];

  List<GconsoChartData> get guideConsoData {
    return [
      ..._guideConsoData
    ];
  }

// END CONSO CHART  ========================
//
//
// START MORT CHART  ========================
  List<MortChartData> _mortData = [];

  List<MortChartData> get mortData {
    return [
      ..._mortData
    ];
  }

  List<GmortChartData> _guideMortData = [];

  List<GmortChartData> get guideMortData {
    return [
      ..._guideMortData
    ];
  }

// END MORT CHART  ========================
//
//
//
// START PV CHART  ========================
  List<PvChartData> _pvData = [];

  List<PvChartData> get pvdata {
    return [
      ..._pvData
    ];
  }

  List<GpvChartData> _guidePvData = [];

  List<GpvChartData> get guidePvData {
    return [
      ..._guidePvData
    ];
  }

// END PV CHART  ========================
//
// START MASSE CHART  ========================
  List<MasseChartData> _masseData = [];

  List<MasseChartData> get massedata {
    return [
      ..._masseData
    ];
  }

  List<GmasseChartData> _guideMasseData = [];

  List<GmasseChartData> get guideMasseData {
    return [
      ..._guideMasseData
    ];
  }

// END MASSE CHART  ========================
//
//
// START IC CHART  ========================
  List<IcChartData> _icData = [];

  List<IcChartData> get icdata {
    return [
      ..._icData
    ];
  }

  List<GicChartData> _guideIcData = [];

  List<GicChartData> get guideIcData {
    return [
      ..._guideIcData
    ];
  }

// END IC CHART  ========================
//
//
// START IC CHART  ========================
  final List<IcChartData> _lightData = [];

  List<IcChartData> get lightdata {
    return [
      ..._lightData
    ];
  }

  final List<GicChartData> _guideLightData = [];

  List<GicChartData> get guideLightData {
    return [
      ..._guideLightData
    ];
  }
// END IC CHART  ========================
//

  Future<void> getCharts({int? lot, String? uri, int? index}) async {
    final url = Uri.parse('${GlobalConf.prodUrl}$uri/?lotId=$lot');

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
        final List reelData = fetchedData["reel"];
        final List guideData = fetchedData["guide"];
        switch (index) {
          case 0:
            prodChartFiller(reelData, guideData); //PROD CHART FILLER
            break;
          case 1:
            consoChartFiller(reelData, guideData); // CONSO CHART FILLER
            break;
          case 2:
            mortChartFiller(reelData, guideData);
            break;
          case 3:
            pvChartFiller(reelData, guideData);
            break;
          case 4:
            masseChartFiller(reelData, guideData);
            break;
          case 5:
            icChartFiller(reelData, guideData);
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

  void prodChartFiller(List reelData, List guideData) {
    final List<ProdChartData> reel = [];
    final List<GprodChartData> guide = [];
    _prodData.clear();
    _guideProdData.clear();
    for (var item in reelData) {
      reel.add(
        ProdChartData(
          age: item["age"],
          ponte: double.parse("${item["ponte"]}"),
          pmo: double.parse("${item["pmo"]}"),
          noppd: double.parse("${item["noppdCuml"]}"),
          blancs: double.parse("${item["blancs"]}"),
          declassed: double.parse("${item["declasse"]}"),
        ),
      );
    }
    for (var item in guideData) {
      guide.add(GprodChartData(
        age: item["age"],
        gPonte: item["G_ponte"],
        gPmo: item["G_pmo"],
        gNoppd: item["G_noppdCuml"],
      ));
    }
    _prodData = reel;
    _guideProdData = guide;
  }

// CONSOMMATION
  void consoChartFiller(List reelData, List guideData) {
    final List<ConsoChartData> reel = [];
    final List<GconsoChartData> guide = [];
    _consoData.clear();
    _guideConsoData.clear();
    for (var item in reelData) {
      reel.add(
        ConsoChartData(
          age: item["age"],
          aps: item["aps"],
          eps: item["eps"],
          apsCuml: item["apsCuml"],
          ratio: item["ratio"],
        ),
      );
    }
    for (var item in guideData) {
      guide.add(GconsoChartData(
        age: item["age"],
        gAps: item["G_aps"],
        gApsCuml: item["G_altCumlPD"],
      ));
    }

    _consoData = reel;
    _guideConsoData = guide;
  }

// Mortalité
  void mortChartFiller(List reelData, List guideData) {
    final List<MortChartData> reel = [];
    final List<GmortChartData> guide = [];
    _mortData.clear();
    _guideMortData.clear();
    for (var item in reelData) {
      reel.add(
        MortChartData(
          age: item["age"],
          mortSem: item["mortSem"],
          mortCuml: item["mortCuml"],
        ),
      );
    }
    for (var item in guideData) {
      guide.add(GmortChartData(
        age: item["age"],
        gMortSem: item["gMortSem"],
        gMortCuml: item["gMortCuml"],
        bar1: item["bar1"],
        bar2: item["bar2"],
        bar3: item["bar3"],
      ));
    }

    _mortData = reel;
    _guideMortData = guide;
  }

// POIDS VIF
  void pvChartFiller(List reelData, List guideData) {
    final List<PvChartData> reel = [];
    final List<GpvChartData> guide = [];
    _pvData.clear();
    _guidePvData.clear();
    for (var item in reelData) {
      reel.add(
        PvChartData(
          age: item["age"],
          poids: double.parse("${item["pv"]}"),
          homog: double.parse("${item["homog"]}"),
        ),
      );
    }
    for (var item in guideData) {
      guide.add(GpvChartData(age: item["age"], pv: item["gPv"]));
    }

    _pvData = reel;
    _guidePvData = guide;
  }

// MASSE D'OEUF
  void masseChartFiller(List reelData, List guideData) {
    final List<MasseChartData> reel = [];
    final List<GmasseChartData> guide = [];
    _masseData.clear();
    _guideMasseData.clear();
    for (var item in reelData) {
      reel.add(
        MasseChartData(
          age: item["age"],
          massSem: double.parse("${item["massSem"]}"),
          massCuml: double.parse("${item["massCuml"]}"),
        ),
      );
    }
    for (var item in guideData) {
      guide.add(GmasseChartData(
        age: item["age"],
        gMassSem: item["gMassSem"],
        gMassCuml: item["gMassCuml"],
      ));
    }
    _masseData = reel;
    _guideMasseData = guide;
  }

// INDICE DE CONVERSION
  void icChartFiller(List reelData, List guideData) {
    final List<IcChartData> reel = [];
    final List<GicChartData> guide = [];
    _icData.clear();
    _guideIcData.clear();
    for (var item in reelData) {
      reel.add(
        IcChartData(
          age: item["age"],
          icCuml: item["icCuml"],
        ),
      );
    }
    for (var item in guideData) {
      guide.add(GicChartData(
        age: item["age"],
        gIcCuml: item["gIcCuml"],
      ));
    }
    _icData = reel;
    _guideIcData = guide;
  }
}
