import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:farmdriverzootech/core/conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalysesProvider with ChangeNotifier {
  final List _analyses = [
    // FETCHED DATA ...
  ];

  List get analyses {
    return [
      ..._analyses
    ];
  }

  final List _lastTwoAnalyses = [
    // FETCHED DATA ...
  ];

  List get lastTwoAnalyses {
    return [
      ..._lastTwoAnalyses
    ];
  }

  Future<void> getAnalyses(lotId) async {
    final url = Uri.parse('${GlobalConf.prodUrl}get-analyse-pdfs/?lot=$lotId');
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
        _analyses.clear();
        for (var item in fetchedProducts) {
          if (item == null) {
            continue;
          }
          _analyses.add(item);
        }
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getLastTwoAnalyses() async {
    final url = Uri.parse('${GlobalConf.prodUrl}get-last-analyse-pdfs/');
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
        _lastTwoAnalyses.clear();
        for (var item in fetchedProducts) {
          if (item == null) {
            continue;
          }
          _lastTwoAnalyses.add(item);
        }
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> downloadPdfForSharing(String fileUrl) async {
    final url = Uri.parse(fileUrl);
    try {
      final response = await http.get(
        url,
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

  Future<void> shareDownloadedPdf(String fileUrl) async {
    try {
      final pdfData = await downloadPdfForSharing(fileUrl);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${pdfData["name"]}');

      await file.writeAsBytes(pdfData["pdf"], flush: true);

      await Share.shareXFiles([
        XFile(file.path)
      ]);
    } catch (e) {
      return;
    }
  }
}
