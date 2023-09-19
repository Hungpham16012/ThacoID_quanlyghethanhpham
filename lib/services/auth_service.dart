import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ghethanhpham_thaco/models/user.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';

class AuthService extends ChangeNotifier {
  static RequestHelper requestHelper = RequestHelper();

  UserModel? _user;
  UserModel? get user => _user;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;
  Future loginWithUsernamePassword(String userName, String password) async {
    try {
      _hasError = false;
      String domain = userName.contains('@') ? "thaco.com.vn" : "";

      // Check if userName contains '@' to determine if it includes a domain
      if (userName.contains('@')) {
        // Split the userName into parts using '@' as a delimiter
        final parts = userName.split('@');

        // The first part will be the username, and the second part will be the domain
        if (parts.length == 2) {
          userName = parts[0]; // Extract the username
          domain = parts[1]; // Extract the domain
        }
      }

      final http.Response response = await requestHelper.loginAction(
        jsonEncode(
          {
            "username": userName,
            "password": password,
            "domain": domain,
          },
        ),
      );

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        var data = decodedData["data"];
        var info = data["info"];

        _user = UserModel(
          id: info['id'],
          email: info['email'],
          fullName: info['fullName'],
          mustChangePass: info['mustChangePass'],
          token: data['token'],
          refreshToken: data['refreshToken'],
          hinhAnhUrl: info['hinhAnhUrl'],
        );
      }
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }
}
