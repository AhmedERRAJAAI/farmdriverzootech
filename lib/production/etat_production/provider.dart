import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:farmdriverzootech/production/performaces_table/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProdStatusProvider with ChangeNotifier {
  static const URL = "https://savasdev.click/production/";
  final List<ProdStatusTableTitles> _titles = TableTitles.prodStatusTb
      .map(
        (ele) => ProdStatusTableTitles(
          name: ele["name"],
          title: ele["title"],
          color: ele["color"],
        ),
      )
      .toList();

  List<ProdStatusTableTitles> get titles {
    return [
      ..._titles,
    ];
  }

  List<ProdStatusData> _reports = [
    // FETCHED DATA ...
  ];

  List<ProdStatusData> get reports {
    return [
      ..._reports
    ];
  }

  Future<void> getProdStatus(date, sites) async {
    final url = Uri.parse('${URL}get-prod-status/?date=$date&sites=$sites');
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
        _reports.clear();
        List<ProdStatusData> tempData = [];
        for (var item in fetchedProducts) {
          if (item == null) {
            continue;
          }
          tempData.add(ProdStatusData(
            site: item["site"],
            batName: item["batName"],
            age: item["age"],
            aliment: item["aliment"],
            intens: item["intens"],
            light: item["light"],
            flash: item["flash"],
            effectif: item["effectif"],
            ratio: item["ratio"],
            eps: item["eps"],
            eau: item["eau"],
            apoSem: item["altOeuf_sem"],
            apoCuml: item["altOeuf_cuml"],
            aps: item["aps"],
            centPonte: item["cent_ponte"],
            kind: item["1"],
            lotCode: item["1"],
            dayOnAge: item["dayOnAge"],
            homog: item["homog"],
            icCuml: item["ic_cuml"],
            icSem: item["ic_sem"],
            massCuml: item["mass_cuml"],
            massSem: item["mass_sem"],
            mort: item["mort"],
            pmo: item["pmo"],
            ponte: item["ponte"],
            pv: item["pv"],
            tempMin: item["temp_min"] != null ? item["temp_min"]["val"] : null,
            tempMax: item["temp_max"] != null ? item["temp_max"]["val"] : null,
          ));
        }

        _reports = tempData;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> downloadProdStatus(date, sites) async {
    final url = Uri.parse('${URL}production-state-pdf/?date=$date&sites=$sites');
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
        final contentDispositionHeader = response.headers['content-disposition'];
        return {
          "pdf": response.bodyBytes,
          "name": contentDispositionHeader?.substring(21)
        };
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> shareProdStatus(date, sites) async {
    try {
      final pdfData = await downloadProdStatus(date, sites);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${pdfData["name"]}');

      await file.writeAsBytes(pdfData["pdf"], flush: true);

      await Share.shareXFiles([
        XFile(file.path)
      ]);
    } catch (e) {
      print('Error sharing PDF: $e');
    }
  }
}

class ProdStatusTableTitles {
  final String title;
  final String name;
  final int color;

  ProdStatusTableTitles({
    required this.title,
    required this.name,
    required this.color,
  });
}

class ProdStatusData {
  var site;
  var age;
  var aliment;
  var apoSem;
  var apoCuml;
  var aps;
  var batName;
  var centPonte;
  var kind;
  var lotCode;
  var dayOnAge;
  var eau;
  var effectif;
  var eps;
  var homog;
  var icCuml;
  var icSem;
  var intens;
  var tempMin;
  var tempMax;
  var light;
  var flash;
  var massCuml;
  var massSem;
  var mort;
  var pmo;
  var ponte;
  var pv;
  var ratio;
  var time;
  ProdStatusData({
    this.site,
    this.age,
    this.aliment,
    this.apoSem,
    this.apoCuml,
    this.aps,
    this.batName,
    this.centPonte,
    this.kind,
    this.lotCode,
    this.dayOnAge,
    this.eau,
    this.effectif,
    this.eps,
    this.homog,
    this.icCuml,
    this.icSem,
    this.intens,
    this.tempMin,
    this.tempMax,
    this.light,
    this.flash,
    this.massCuml,
    this.massSem,
    this.mort,
    this.pmo,
    this.ponte,
    this.pv,
    this.ratio,
    this.time,
  });
}
