import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:farmdriverzootech/production/performaces_table/constants.dart';
import 'package:farmdriverzootech/production/performaces_table/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TableProvider with ChangeNotifier {
  static const URL = "https://savasdev.click/production/";
  String stringifier(input) {
    return "$input";
  }

  final List<TableTitle> _titles = TableTitles.tableTitles
      .map(
        (ele) => TableTitle(
          name: ele["name"],
          title: ele["title"],
          fullName: ele["fullName"] ?? "-",
          isActive: true,
          color: TableTitles.colors[ele["color"]],
          colorIndex: ele["color"],
          order: ele["order"],
        ),
      )
      .toList();

  List<TableTitle> get titles {
    _titles.sort((a, b) => (a.order).compareTo(b.order));
    return [
      ..._titles,
    ];
  }

  void toggleActiveStatus(String name) {
    titles.firstWhere((element) => element.name == name).toggleActiveStatus();
    notifyListeners();
  }

  List<TblRow> _reports = [
    // FETCHED DATA ...
  ];

  List<TblRow> get reports {
    return [
      ..._reports
    ];
  }

  Future<void> getTableReports(lotId) async {
    final url = Uri.parse('${URL}get-prod-table-data/?lotId=$lotId&justWeek=1');

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
        final data = json.decode(responseBody) as List;
        final List<TblRow> extractedData = [];
        _reports.clear();
        for (var item in data) {
          extractedData.add(
            TblRow(
              humidity: item["humidity"] != null ? item["humidity"].toString() : "-",
              deletable: false,
              isFinal: false,
              id: item["lot_id"],
              // CALENDAR ---------------------------------------
              semCivil: item["semCivil"],
              date: item["date"],
              age: item["age"],
              // AMBIANCE ---------------------------------------
              light: Light(
                on: item["lumiere"]["starts_at"],
                off: item["lumiere"]["ends_at"],
                durration: item["lumiere"]["period"],
                isFlash: false,
              ),

              flash: Light(
                on: item["flash"]["starts_at"],
                off: item["flash"]["ends_at"],
                durration: item["flash"]["period"],
                isFlash: true,
              ),
              intensite: item["intensite"],
              intensUnit: item["intensite_unit"],
              temp: Temperature(
                min: item["temperature"]["min"],
                max: item["temperature"]["max"],
              ),
              //  Viability ---------------------------------------
              effectif: item["effectif"],
              viability: item["viabilite"],
              homog: Ordinary.fromDynamic(
                reel: item["homog"]["reel"],
                ecart: item["homog"]["ecart"],
                guide: item["homog"]["guide"],
                color: item["homog"]["color"],
              ),
              pv: Ordinary.fromDynamic(
                reel: item["poid_vif"]["reel"],
                ecart: item["poid_vif"]["ecart"],
                guide: item["poid_vif"]["guide"],
                color: item["poid_vif"]["color"],
              ),
              mortSem: Ordinary.fromDynamic(
                reel: item["cent_mort_sem"]["reel"],
                ecart: item["cent_mort_sem"]["ecart"],
                guide: item["cent_mort_sem"]["guide"],
                color: item["cent_mort_sem"]["color"],
              ),
              mortCuml: Ordinary.fromDynamic(
                reel: item["cent_mort_cuml"]["reel"],
                ecart: item["cent_mort_cuml"]["ecart"],
                guide: item["cent_mort_cuml"]["guide"],
                color: item["cent_mort_cuml"]["color"],
              ),
              //  CONSOMMATION ---------------------------------------
              altCuml: Ordinary.fromDynamic(
                reel: item["alt_cuml"]["reel"],
                ecart: item["alt_cuml"]["ecart"],
                guide: item["alt_cuml"]["guide"],
                color: item["alt_cuml"]["color"],
              ),
              aps: Ordinary.fromDynamic(
                reel: item["aps"]["reel"],
                ecart: item["aps"]["ecart"],
                guide: item["aps"]["guide"],
                color: item["aps"]["color"],
              ),
              ratio: ReelColor(
                reel: "${item["ratio"]["reel"]}",
                color: item["ratio"]["color"],
              ),

              eauDist: item["eau_dist"],
              eps: item["eps"],
              altDist: TwoValues(
                reel: item["alt_dist"]["sem"],
                variat: item["alt_dist"]["cuml"],
              ),
              refAlt: item["formule_ep"],
              deliveredAlt: TwoValues(
                reel: item["delivered_alt_dist"]['sem'],
                variat: item["delivered_alt_dist"]['cuml'],
              ),
              deliveredAltPerHen: TwoValues(
                reel: item["delivered_alt_per_hen"]['sem'],
                variat: item["delivered_alt_per_hen"]['cuml'],
              ),
              deliveredAltPrice: TwoValues(
                reel: item["alt_price"]['sem'],
                variat: item["alt_price"]['cuml'],
              ),

              // PRODUCTION ---------------------------------------
              ponteNbr: WithVariation(
                variat: "${item['ponte']["ponte_var"]["reel"]}",
                reel: "${item['ponte']["ponte_nbr"]}",
                color: item['ponte']["ponte_var"]["color"],
              ),
              ponteCent: Ordinary.fromDynamic(
                reel: item["ponte_cent"]["reel"],
                ecart: item["ponte_cent"]["ecart"],
                guide: item["ponte_cent"]["guide"],
                color: item["ponte_cent"]["color"],
              ),
              pmo: Ordinary.fromDynamic(
                reel: item["pmo"]["reel"],
                ecart: item["pmo"]["ecart"],
                guide: item["pmo"]["guide"],
                color: item["pmo"]["color"],
              ),
              nopppSem: Ordinary.fromDynamic(
                reel: item["noppp"]["reel"],
                ecart: item["noppp"]["ecart"],
                guide: item["noppp"]["guide"],
                color: item["noppp"]["color"],
              ),
              noppp: Ordinary.fromDynamic(
                reel: item["noppp_cuml_sem"]["reel"],
                ecart: item["noppp_cuml_sem"]["ecart"],
                guide: item["noppp_cuml_sem"]["guide"],
                color: item["noppp_cuml_sem"]["color"],
              ),
              noppdSem: Ordinary.fromDynamic(
                reel: item["noppd"]["reel"],
                ecart: item["noppd"]["ecart"],
                guide: item["noppd"]["guide"],
                color: item["noppd"]["color"],
              ),
              noppd: Ordinary.fromDynamic(
                reel: item["noppd_cuml_sem"]["reel"],
                ecart: item["noppd_cuml_sem"]["ecart"],
                guide: item["noppd_cuml_sem"]["guide"],
                color: item["noppd_cuml_sem"]["color"],
              ),
              declasse: TwoValues(
                reel: item["declassed"]["nbr"].toString(),
                variat: "${item["declassed"]["percenatage"]}%",
                hasColor: true,
              ),
              // Masse d'oeuf ----------------------------------------
              massOeufPP: Ordinary.fromDynamic(
                reel: item["mass_oeuf_pp"]["reel"],
                ecart: item["mass_oeuf_pp"]["ecart"],
                guide: item["mass_oeuf_pp"]["guide"],
                color: item["mass_oeuf_pp"]["color"],
              ),
              massOeufSemPP: Ordinary.fromDynamic(
                reel: item["mass_oeuf_sem_pp"]["reel"],
                ecart: item["mass_oeuf_sem_pp"]["ecart"],
                guide: item["mass_oeuf_sem_pp"]["guide"],
                color: item["mass_oeuf_sem_pp"]["color"],
              ),
              massOeufPD: Ordinary.fromDynamic(
                reel: item["mass_oeuf_pd"]["reel"],
                ecart: item["mass_oeuf_pd"]["ecart"],
                guide: item["mass_oeuf_pd"]["guide"],
                color: item["mass_oeuf_pd"]["color"],
              ),
              massOeufSemPD: Ordinary.fromDynamic(
                reel: item["mass_oeuf_sem_pd"]["reel"],
                ecart: item["mass_oeuf_sem_pd"]["ecart"],
                guide: item["mass_oeuf_sem_pd"]["guide"],
                color: item["mass_oeuf_sem_pd"]["color"],
              ),
              // INDICES DE CONVERSION ---------------------------------
              altOeuf: Ordinary.fromDynamic(
                reel: item["alt_oeuf"]["reel"],
                ecart: item["alt_oeuf"]["ecart"],
                guide: item["alt_oeuf"]["guide"],
                color: item["alt_oeuf"]["color"],
              ),
              altOeufCuml: Ordinary.fromDynamic(
                reel: item["alt_oeuf_cuml"]["reel"],
                ecart: item["alt_oeuf_cuml"]["ecart"],
                guide: item["alt_oeuf_cuml"]["guide"],
                color: item["alt_oeuf_cuml"]["color"],
              ),
              icCuml: Ordinary.fromDynamic(
                reel: item["ic_cuml"]["reel"],
                ecart: item["ic_cuml"]["ecart"],
                guide: item["ic_cuml"]["guide"],
                color: item["ic_cuml"]["color"],
              ),
            ),
          );
        }
        _reports = extractedData;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

//
//
//
//
// ONE WEEK =========================================
//
//
//
//

  List<TblRow> _oneWeekReps = [
    // FETCHED DATA ...
  ];

  List<TblRow> get oneWeekReps {
    return [
      ..._oneWeekReps
    ];
  }

  Future<void> getOneWeekData(lotId, age) async {
    final url = Uri.parse('${URL}get-prod-table-data/?lotId=$lotId&justWeek=0&age=$age');

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
        _oneWeekReps.clear();
        final responseBody = utf8.decode(response.bodyBytes);
        final weekData = json.decode(responseBody) as Map;
        final List<TblRow> extractedData = [];

        //loop over days
        for (var item in weekData["data"]) {
          if (item["id"] == null) {
            continue;
          }
          extractedData.add(TblRow(
            deliveredAlt: TwoValues(reel: item["delivered_alt_dist"], variat: ''),
            deliveredAltPerHen: TwoValues(reel: item["delivered_alt_pen_hen"], variat: ''),
            deliveredAltPrice: TwoValues(reel: item['alt_price'], variat: ''),
            humidity: item["humidity"] != null ? item["humidity"].toString() : "-",
            deletable: item["deletable"],
            isFinal: false,
            id: item["id"],
            // CALENDAR ---------------------------------------
            semCivil: item["semCivil"],
            date: item["date"],
            age: item["age"],
            // AMBIANCE ---------------------------------------
            light: Light(
              on: item["lumiere"]["starts_at"],
              off: item["lumiere"]["ends_at"],
              durration: item["lumiere"]["period"],
              isFlash: false,
            ),
            flash: Light(
              on: item["flash"]["starts_at"],
              off: item["flash"]["ends_at"],
              durration: item["flash"]["period"],
              isFlash: true,
            ),
            intensite: item["intensite"],
            intensUnit: item["intensite_unit"],
            temp: Temperature(
              min: item["temperature"]["min"],
              max: item["temperature"]["max"],
            ),
            //  Viability ---------------------------------------
            effectif: item["effectif"],
            viability: item["viabilite"],

            homog: Ordinary.fromDynamic(
              reel: stringifier(item["homog"]),
              ecart: null,
              guide: null,
              color: null,
            ),
            pv: Ordinary.fromDynamic(
              reel: stringifier(item["poid_vif"]),
              ecart: null,
              guide: null,
              color: null,
            ),
            mortSem: Ordinary.fromDynamic(
              reel: stringifier(item["nbr_mort_jour"]),
              ecart: null,
              guide: null,
              color: null,
            ),
            mortCuml: Ordinary.fromDynamic(
              reel: stringifier(item["nbr_mort_sem"]),
              ecart: null,
              guide: null,
              color: null,
            ),
            //  CONSOMMATION ---------------------------------------
            altCuml: Ordinary.fromDynamic(
              reel: stringifier(item["alt_cuml"]),
              ecart: null,
              guide: null,
              color: null,
            ),
            aps: Ordinary.fromDynamic(
              reel: stringifier(item["aps"]),
              ecart: null,
              guide: null,
              color: null,
            ),
            ratio: ReelColor(
              reel: stringifier(item["ratio"]),
              color: null,
            ),

            eauDist: item["eau_dist"],
            eps: item["eps"],
            altDist: TwoValues(reel: item["alt_dist"]),
            refAlt: item["formule_ep"],

            // PRODUCTION ---------------------------------------
            ponteNbr: WithVariation(
              reel: "${item['ponte']["ponte_nbr"]}",
              variat: "${item["ponte_var"]["reel"]}",
              color: item["ponte_var"]["color"],
            ),
            ponteCent: Ordinary.fromDynamic(
              reel: item["ponte_cent"],
              ecart: null,
              guide: null,
              color: null,
            ),
            pmo: Ordinary.fromDynamic(
              reel: item["pmo"],
              ecart: null,
              guide: null,
              color: null,
            ),
            noppp: Ordinary.fromDynamic(
              reel: item["noppp_cuml_jr"],
              ecart: null,
              guide: null,
              color: null,
            ),
            nopppSem: Ordinary.fromDynamic(
              reel: item["noppp"],
              ecart: null,
              guide: null,
              color: null,
            ),
            noppd: Ordinary.fromDynamic(
              reel: item["noppd_cuml_jr"],
              ecart: null,
              guide: null,
              color: null,
            ),
            noppdSem: Ordinary.fromDynamic(
              reel: item["noppd"],
              ecart: null,
              guide: null,
              color: null,
            ),
            declasse: TwoValues(reel: item["declassed"]),
            // Masse d'oeuf ----------------------------------------
            massOeufPP: Ordinary.fromDynamic(
              reel: item["mass_oeuf_pp"],
              ecart: null,
              guide: null,
              color: null,
            ),
            massOeufSemPP: Ordinary.fromDynamic(
              reel: item["mass_oeuf_sem_pp"],
              ecart: null,
              guide: null,
              color: null,
            ),
            massOeufPD: Ordinary.fromDynamic(
              reel: item["mass_oeuf_pd"],
              ecart: null,
              guide: null,
              color: null,
            ),
            massOeufSemPD: Ordinary.fromDynamic(
              reel: item["mass_oeuf_sem_pd"],
              ecart: null,
              guide: null,
              color: null,
            ),
            // INDICES DE CONVERSION ---------------------------------
            altOeuf: Ordinary.fromDynamic(
              reel: item["alt_oeuf_jr"],
              ecart: null,
              guide: null,
              color: null,
            ),
            altOeufCuml: Ordinary.fromDynamic(
              reel: item["alt_oeuf_jr_cuml"],
              ecart: null,
              guide: null,
              color: null,
            ),
            icCuml: Ordinary.fromDynamic(
              reel: item["ic"],
              ecart: null,
              guide: null,
              color: null,
            ),
          ));
        }
        _oneWeekReps = extractedData;
        _oneWeekReps.add(
          TblRow(
            deletable: false,
            isFinal: false,
            id: weekData["lot_id"],
            // CALENDAR ---------------------------------------
            semCivil: weekData["semCivil"],
            date: weekData["date"],
            age: weekData["age"],
            // AMBIANCE ---------------------------------------
            light: Light(
              on: weekData["lumiere"]["starts_at"],
              off: weekData["lumiere"]["ends_at"],
              durration: weekData["lumiere"]["period"],
              isFlash: false,
            ),
            flash: Light(
              on: weekData["flash"]["starts_at"],
              off: weekData["flash"]["ends_at"],
              durration: weekData["flash"]["period"],
              isFlash: true,
            ),
            intensite: weekData["intensite"],
            intensUnit: weekData["intensite_unit"],
            temp: Temperature(
              min: weekData["temperature"]["min"],
              max: weekData["temperature"]["max"],
            ),
            //  Viability ---------------------------------------
            effectif: weekData["effectif"],
            viability: weekData["viabilite"],
            homog: Ordinary.fromDynamic(
              reel: weekData["homog"]["reel"],
              ecart: weekData["homog"]["ecart"],
              guide: weekData["homog"]["guide"],
              color: weekData["homog"]["color"],
            ),
            pv: Ordinary.fromDynamic(
              reel: weekData["poid_vif"]["reel"],
              ecart: weekData["poid_vif"]["ecart"],
              guide: weekData["poid_vif"]["guide"],
              color: weekData["poid_vif"]["color"],
            ),
            mortSem: Ordinary.fromDynamic(
              reel: weekData["cent_mort_sem"]["reel"],
              ecart: weekData["cent_mort_sem"]["ecart"],
              guide: weekData["cent_mort_sem"]["guide"],
              color: weekData["cent_mort_sem"]["color"],
            ),
            mortCuml: Ordinary.fromDynamic(
              reel: weekData["cent_mort_cuml"]["reel"],
              ecart: weekData["cent_mort_cuml"]["ecart"],
              guide: weekData["cent_mort_cuml"]["guide"],
              color: weekData["cent_mort_cuml"]["color"],
            ),
            //  CONSOMMATION ---------------------------------------
            altCuml: Ordinary.fromDynamic(
              reel: weekData["alt_cuml"]["reel"],
              ecart: weekData["alt_cuml"]["ecart"],
              guide: weekData["alt_cuml"]["guide"],
              color: weekData["alt_cuml"]["color"],
            ),
            aps: Ordinary.fromDynamic(
              reel: weekData["aps"]["reel"],
              ecart: weekData["aps"]["ecart"],
              guide: weekData["aps"]["guide"],
              color: weekData["aps"]["color"],
            ),
            ratio: ReelColor(
              reel: "${weekData["ratio"]["reel"]}",
              color: weekData["ratio"]["color"],
            ),

            eauDist: weekData["eau_dist"],
            eps: weekData["eps"],
            altDist: TwoValues(
              reel: weekData["alt_dist"]["sem"],
              variat: weekData["alt_dist"]["cuml"],
            ),
            refAlt: weekData["formule_ep"],
            deliveredAlt: TwoValues(
              reel: weekData["delivered_alt_dist"]['sem'],
              variat: weekData["delivered_alt_dist"]['cuml'],
            ),
            deliveredAltPerHen: TwoValues(
              reel: weekData["delivered_alt_per_hen"]['sem'],
              variat: weekData["delivered_alt_per_hen"]['cuml'],
            ),
            deliveredAltPrice: TwoValues(
              reel: weekData["alt_price"]['sem'],
              variat: weekData["alt_price"]['cuml'],
            ),

            // PRODUCTION ---------------------------------------
            ponteNbr: WithVariation(
              variat: "${weekData['ponte']["ponte_var"]["reel"]}",
              reel: "${weekData['ponte']["ponte_nbr"]}",
              color: weekData['ponte']["ponte_var"]["color"],
            ),
            ponteCent: Ordinary.fromDynamic(
              reel: weekData["ponte_cent"]["reel"],
              ecart: weekData["ponte_cent"]["ecart"],
              guide: weekData["ponte_cent"]["guide"],
              color: weekData["ponte_cent"]["color"],
            ),
            pmo: Ordinary.fromDynamic(
              reel: weekData["pmo"]["reel"],
              ecart: weekData["pmo"]["ecart"],
              guide: weekData["pmo"]["guide"],
              color: weekData["pmo"]["color"],
            ),
            nopppSem: Ordinary.fromDynamic(
              reel: weekData["noppp"]["reel"],
              ecart: weekData["noppp"]["ecart"],
              guide: weekData["noppp"]["guide"],
              color: weekData["noppp"]["color"],
            ),
            noppp: Ordinary.fromDynamic(
              reel: weekData["noppp_cuml_sem"]["reel"],
              ecart: weekData["noppp_cuml_sem"]["ecart"],
              guide: weekData["noppp_cuml_sem"]["guide"],
              color: weekData["noppp_cuml_sem"]["color"],
            ),
            noppdSem: Ordinary.fromDynamic(
              reel: weekData["noppd"]["reel"],
              ecart: weekData["noppd"]["ecart"],
              guide: weekData["noppd"]["guide"],
              color: weekData["noppd"]["color"],
            ),
            noppd: Ordinary.fromDynamic(
              reel: weekData["noppd_cuml_sem"]["reel"],
              ecart: weekData["noppd_cuml_sem"]["ecart"],
              guide: weekData["noppd_cuml_sem"]["guide"],
              color: weekData["noppd_cuml_sem"]["color"],
            ),
            declasse: TwoValues(
              reel: weekData["declassed"]["nbr"].toString(),
              variat: "${weekData["declassed"]["percenatage"]}%",
              hasColor: true,
            ),
            // Masse d'oeuf ----------------------------------------
            massOeufPP: Ordinary.fromDynamic(
              reel: weekData["mass_oeuf_pp"]["reel"],
              ecart: weekData["mass_oeuf_pp"]["ecart"],
              guide: weekData["mass_oeuf_pp"]["guide"],
              color: weekData["mass_oeuf_pp"]["color"],
            ),
            massOeufSemPP: Ordinary.fromDynamic(
              reel: weekData["mass_oeuf_sem_pp"]["reel"],
              ecart: weekData["mass_oeuf_sem_pp"]["ecart"],
              guide: weekData["mass_oeuf_sem_pp"]["guide"],
              color: weekData["mass_oeuf_sem_pp"]["color"],
            ),
            massOeufPD: Ordinary.fromDynamic(
              reel: weekData["mass_oeuf_pd"]["reel"],
              ecart: weekData["mass_oeuf_pd"]["ecart"],
              guide: weekData["mass_oeuf_pd"]["guide"],
              color: weekData["mass_oeuf_pd"]["color"],
            ),
            massOeufSemPD: Ordinary.fromDynamic(
              reel: weekData["mass_oeuf_sem_pd"]["reel"],
              ecart: weekData["mass_oeuf_sem_pd"]["ecart"],
              guide: weekData["mass_oeuf_sem_pd"]["guide"],
              color: weekData["mass_oeuf_sem_pd"]["color"],
            ),
            // INDICES DE CONVERSION ---------------------------------
            altOeuf: Ordinary.fromDynamic(
              reel: weekData["alt_oeuf"]["reel"],
              ecart: weekData["alt_oeuf"]["ecart"],
              guide: weekData["alt_oeuf"]["guide"],
              color: weekData["alt_oeuf"]["color"],
            ),
            altOeufCuml: Ordinary.fromDynamic(
              reel: weekData["alt_oeuf_cuml"]["reel"],
              ecart: weekData["alt_oeuf_cuml"]["ecart"],
              guide: weekData["alt_oeuf_cuml"]["guide"],
              color: weekData["alt_oeuf_cuml"]["color"],
            ),
            icCuml: Ordinary.fromDynamic(
              reel: weekData["ic_cuml"]["reel"],
              ecart: weekData["ic_cuml"]["ecart"],
              guide: weekData["ic_cuml"]["guide"],
              color: weekData["ic_cuml"]["color"],
            ),
          ),
        );
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

//
//
//
//
// DELETE REPORT =========================================
//
//
//
//

  Future<void> deleteReport(id) async {
    final url = Uri.parse('${URL}delete-report/?id=$id');

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
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

//
//
//
//
  // DOWNLOAD WEEK PDF
//
//
//
//
//

  Future<Map<String, dynamic>> downloadWeekPdf(lotId, age) async {
    final url = Uri.parse('${URL}pdf-week/?lot_id=$lotId&age=$age');
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
      throw Exception("ERROR DURING DOWNLOADING PDF");
    }
  }

  Future<void> shareWeekReport(lotId, age) async {
    try {
      final pdfData = await downloadWeekPdf(lotId, age);
      final directory = await getTemporaryDirectory();
      String sanitizedFileName = pdfData["name"].replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final file = File('${directory.path}/$sanitizedFileName');

      await file.writeAsBytes(pdfData["pdf"], flush: true);

      await Share.shareXFiles([
        XFile(file.path)
      ]);
    } catch (e) {
      print('Error sharing PDF: $e');
    }
  }

  //
  //
  //
  //
  // GET WEEK CONSTATS
  //
  //
  //
  List _weekConstats = [
    // FETCHED DATA ...
  ];

  List get weekConstats {
    return [
      ..._weekConstats
    ];
  }

  Future<void> getRowSecondaryData(lotId, age) async {
    final url = Uri.parse('${URL}get-table-row-details/?lotId=$lotId&age=$age');
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
        _weekConstats.clear();
        final responseBody = utf8.decode(response.bodyBytes);
        _weekConstats = json.decode(responseBody) as List;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
