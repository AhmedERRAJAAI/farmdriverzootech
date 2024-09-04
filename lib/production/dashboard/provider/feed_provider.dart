import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:farmdriverzootech/core/conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedProvider with ChangeNotifier {
  List _feedPosts = [
    // FETCHED DATA ...
  ];

  List get feedPosts {
    return [
      ..._feedPosts
    ];
  }

// READ
  Future<void> fetchFeedPosts(count, siteId) async {
    final url = Uri.parse('${GlobalConf.prodUrl}get-dash-observations/?${siteId != null ? 'site_id=$siteId' : ''}&${count != null ? "count=$count" : ""}');

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
        _feedPosts.clear();
        final responseBody = utf8.decode(response.bodyBytes);
        final data = json.decode(responseBody) as List;
        _feedPosts = data;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

// ADD
  Future<void> addNewPost(File? selectedImage, Map data) async {
    final url = Uri.parse('${GlobalConf.prodUrl}add-dash-observation/');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    try {
      var request = http.MultipartRequest('POST', url)..headers['Authorization'] = 'Bearer $accessToken';
      // Add the data fields
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      // Attach the image if it is provided
      if (selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('observ_img', selectedImage.path),
        );
      }
      var response = await request.send();

      if (response.statusCode == 401) {
        throw Exception(response.statusCode);
      } else {
        fetchFeedPosts(null, null);
      }
    } catch (e) {
      rethrow;
    }
  }

// DELETE
  Future<void> deletePost(id) async {
    final url = Uri.parse('${GlobalConf.prodUrl}delete-dash-observation/');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await http.delete(url,
          headers: headers,
          body: json.encode({
            "id": id
          }));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        fetchFeedPosts(null, null);
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
