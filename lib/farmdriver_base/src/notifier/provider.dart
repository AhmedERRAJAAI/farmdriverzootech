import 'dart:async';
import 'dart:convert';

import 'package:farmdriverzootech/core/conf.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationProvider {
  static Future<void> setPhoneKey(key) async {
    final url = Uri.parse('${GlobalConf.prodUrl}update-user-site/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    Map userData = jsonDecode(prefs.getString('userdata') ?? '');
    final accessToken = userData['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final body = json.encode({
      "phone_key": key,
      'user_id': userData["user_id"]
    });
    try {
      final response = await http.put(url, headers: headers, body: body);
      print("sent success");
      if (response.statusCode >= 200 && response.statusCode < 300) {
      } else {
        print("sent failed");

        throw Exception(response.statusCode);
      }
    } catch (e) {
      print("sent failed");

      rethrow;
    }
  }
}
