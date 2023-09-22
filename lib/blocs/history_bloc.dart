import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/models/history/history_model.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';
import 'package:http/http.dart' as http;

class HistoryBloc extends ChangeNotifier {
  static RequestHelper requestHelper = RequestHelper();

  List<HistoryModel> _listNhapKho = [];
  List<HistoryModel> get listNhapKho => _listNhapKho;

  List<HistoryModel> _listXuatKho = [];
  List<HistoryModel> get listXuatKho => _listXuatKho;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _success = false;
  bool get success => _success;

  String? _message;
  String? get message => _message;

  Future getData(String ngay, bool isNhapKho) async {
    _isLoading = true;
    try {
      final http.Response response = await requestHelper
          .getData('Mobile/LichSu?Ngay=$ngay&isNhapKho=$isNhapKho');
      var decodedData = jsonDecode(response.body);
      if (isNhapKho) {
        _listNhapKho = (decodedData['data'] as List).map((item) {
          return HistoryModel.fromJson(item);
        }).toList();
      } else {
        _listXuatKho = (decodedData['data'] as List).map((item) {
          return HistoryModel.fromJson(item);
        }).toList();
      }
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
