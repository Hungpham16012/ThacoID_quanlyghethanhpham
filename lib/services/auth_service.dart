import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:linhkiennhua_thaco/models/user.dart';
import 'package:linhkiennhua_thaco/services/request_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final http.Response response = await requestHelper.loginAction(
        jsonEncode(
          {
            "username": userName,
            "password": password,
            "domain": "",
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
