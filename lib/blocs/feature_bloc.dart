import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ghethanhpham_thaco/models/chuc_nang.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';
import 'package:http/http.dart' as http;

class FeatureBloc extends ChangeNotifier {
  static RequestHelper requestHelper = RequestHelper();

  List<NhomChucNangModel> _data = [];
  List<NhomChucNangModel> get data => _data;

  

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _success = false;
  bool get success => _success;

  String? _message;
  String? get message => _message;

  int? _statusCode;
  int? get statusCode => _statusCode;

  Future<void> getData() async {
    _isLoading = true;
    try {
      final http.Response response =
          await requestHelper.getData('Mobile/ChucNang');
      _statusCode = response.statusCode;

      if (_statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        _data = (decodedData['data'] as List).map((item) {
          return NhomChucNangModel.fromJson(item);
        }).toList();
        _success = decodedData["success"];
        _message = decodedData["message"];
      } else {
        _message = 'HTTP Error $_statusCode: ${response.reasonPhrase}';
      }
    } catch (e) {
      _message = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
