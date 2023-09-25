import 'dart:convert';

import 'package:ghethanhpham_thaco/models/hoachat.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';

class HoaChatBloc extends ChangeNotifier {
  static RequestHelper requestHelper = RequestHelper();

  HoaChatModel? _hoaChatData;
  HoaChatModel? get hoaChatModel => _hoaChatData;

  List<HoaChatModel?> _listHoaChatISO = [];
  List<HoaChatModel?> get listHoaChatISO => _listHoaChatISO;

  List<HoaChatModel?> _listHoaChatPoly = [];
  List<HoaChatModel?> get listHoaChatPoly => _listHoaChatPoly;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _success = false;
  bool get success => _success;

  String? _message;
  String? get message => _message;

  Future getDataHoaChat(String mahoachat) async {
    _isLoading = true;
    try {
      final http.Response response =
          await requestHelper.getData('HoaChat?Keyword=$mahoachat');
      var decodedData = jsonDecode(response.body);
      if (mahoachat == "ISO") {
        _listHoaChatISO = (decodedData['data'] as List).map((item) {
          return HoaChatModel.fromJson(item);
        }).toList();
      }
      if (mahoachat == "POLY") {
        _listHoaChatPoly = (decodedData['data'] as List).map((item) {
          return HoaChatModel.fromJson(item);
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
