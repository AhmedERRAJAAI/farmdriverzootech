// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:farmdriverzootech/core/conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditNotificationProvider with ChangeNotifier {
  final List<EditNotification> _editNotifications = [
    // FETCHED DATA ...
  ];

  List<EditNotification> get editNotifications {
    return [
      ..._editNotifications
    ];
  }

  Map _modificationDetails = {};

  Map get modificationDetails {
    return _modificationDetails;
  }

  Future<void> geteditNotifications(count, start, end) async {
    final url = Uri.parse('${GlobalConf.prodUrl}get-edit-notifications/?count=$count&start=$start&end=$end');
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
        _editNotifications.clear();
        for (var item in data) {
          _editNotifications.add(EditNotification(batiment: item["batiment"], date: item["date"], editType: item["edit_type"], lotCode: item["lot"], modId: item["mod_id"], rapportId: item["rapport_id"], time: item["time"], user: item["user"], userId: item["user_id"], rapportDate: item["date_rapport"]));
        }
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getEditDetails(modId) async {
    final url = Uri.parse('${GlobalConf.prodUrl}get-updated-report-history/?id=$modId');
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
        _modificationDetails.clear();
        _modificationDetails = data;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}

class EditNotification {
  final String batiment;
  final String date;
  final String time;
  final int editType;
  final String lotCode;
  final int modId;
  final int rapportId;
  final String rapportDate;
  final String user;
  final int userId;

  EditNotification({
    required this.batiment,
    required this.date,
    required this.time,
    required this.editType,
    required this.lotCode,
    required this.modId,
    required this.rapportId,
    required this.rapportDate,
    required this.user,
    required this.userId,
  });
}
