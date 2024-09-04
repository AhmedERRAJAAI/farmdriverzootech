import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SyntheseProvider with ChangeNotifier {
  static const URL = "https://savasdev.click/production/";
  List _sitesTitles = [];
  List get sitesTitles {
    return [
      ..._sitesTitles
    ];
  }

  List _data = [];
  List get data {
    return [
      ..._data
    ];
  }

  Future<void> fetchSyntheseData(finished, age, sites) async {
    final url = Uri.parse('${URL}synthese-pdf/?finished=$finished&isMobile=1&age=$age&sites=$sites');
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
        final responseBody = utf8.decode(response.bodyBytes);
        final fetched = json.decode(responseBody) as Map;
        _sitesTitles = fetched["sites"];
        _data = fetched["data"];
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception("ERROR DURING DOWNLOADING PDF");
    }
  }

  Future<Map<String, dynamic>> downloadPdfForSharing(finished, age, sites) async {
    final url = Uri.parse('${URL}synthese-pdf/?finished=$finished&age=$age&sites=$sites');
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

  Future<void> shareDownloadedPdf(finished, age, sites) async {
    try {
      final pdfData = await downloadPdfForSharing(finished, age, sites);
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
