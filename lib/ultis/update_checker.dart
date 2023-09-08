import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:ghethanhpham_thaco/services/request_helper.dart';
// import '../services/request_helper.dart';

class UpdateChecker {
  static RequestHelper requestHelper = RequestHelper();
  final BuildContext context;
  final String baseApiUrl;
  final String currentVersion;

  UpdateChecker({
    required this.context,
    required this.baseApiUrl,
    required this.currentVersion,
  });

  checkForUpdate() async {
    int statusCode = 200;
    try {
      var values = {
        "maPhienBan": "none",
        "fileName": "none",
        "fileUrl": "none",
        "isCapNhat": false,
        "moTa": "none",
      };

      http.Response response = await requestHelper.getData("PhienBan/KiemTra");
      statusCode = response.statusCode;
      var decodedData = jsonDecode(response.body);
      var data = decodedData["data"];
      var info = data["info"];
      // covert data
      values = {
        "maPhienBan": info["maPhienBan"],
        "fileName": info["fileName"],
        "fileUrl": info["fileUrl"],
        "isCapNhat": data["isCapNhat"],
        "moTa": info["moTa"],
      };
      return values;
    } catch (e) {
      print("Error checking for update: $e");
      return statusCode;
    }
  }
}
