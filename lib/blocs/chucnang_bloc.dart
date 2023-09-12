import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/models/chuc_nang.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';
import 'package:http/http.dart' as http;

class ChucNangBloc extends ChangeNotifier {
  static RequestHelper requestHelper = RequestHelper();

  List<ChucNangModel> _data = [];
  List<ChucNangModel> get data => _data;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _success = false;
  bool get success => _success;

  String? _message;
  String? get message => _message;

  int? _statusCode;
  int? get statusCode => _statusCode;

  Future getData() async {
    _isLoading = true;
    try {
      final http.Response response =
          await requestHelper.getData('Mobile/ChucNang');
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        _data = (decodedData['data'] as List).map((item) {
          return ChucNangModel.fromJson(item);
        }).toList();
        _success = decodedData["success"];
        _message = decodedData["message"];
      }
      _statusCode = response.statusCode;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
