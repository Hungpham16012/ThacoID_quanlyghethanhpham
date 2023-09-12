import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/models/mamau.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';
import 'package:http/http.dart' as http;

class MauBloc extends ChangeNotifier {
  static RequestHelper requestHelper = RequestHelper();

  List<MauModel> _listMau = [];
  List<MauModel> get listMau => _listMau;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _success = false;
  bool get success => _success;

  String? _message;
  String? get message => _message;

  Future getData() async {
    _isLoading = true;
    try {
      final http.Response response =
          await requestHelper.getData('api/BangMaMau');
      var decodedData = jsonDecode(response.body);

      _listMau = (decodedData['data'] as List).map((item) {
        return MauModel.fromJson(item);
      }).toList();

      _isLoading = false;
      _success = decodedData["success"];
      _message = decodedData["message"];
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
