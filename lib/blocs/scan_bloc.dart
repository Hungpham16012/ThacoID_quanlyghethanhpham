import 'dart:convert';
import 'package:ghethanhpham_thaco/models/aonem.dart';
import 'package:ghethanhpham_thaco/models/banle_model.dart';
import 'package:ghethanhpham_thaco/models/export_model.dart';
import 'package:ghethanhpham_thaco/models/hoachat.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:ghethanhpham_thaco/models/scan.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';

class ScanBloc extends ChangeNotifier {
  static RequestHelper requestHelper = RequestHelper();

  ScanModel? _data;
  ScanModel? get data => _data;

  // model xuất theo kệ
  ExportModel? _exportData;
  ExportModel? get exportData => _exportData;

  // model xuất bán lẻ
  BanLeModel? _banleData;
  BanLeModel? get banleData => _banleData;

  // model aonem
  AoNemGheModel? _aoNemData;
  AoNemGheModel? get aoNemData => _aoNemData;

  HoaChatModel? _hoaChatData;
  HoaChatModel? get hoaChatModel => _hoaChatData;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _success = false;
  bool get success => _success;

  String? _message;
  String? get message => _message;

  Future getData(String qrCode, bool isNhapKho) async {
    _isLoading = true;
    _data = null;
    try {
      final http.Response response = await requestHelper
          .getData('Mobile/ThongTin?Qrcode=$qrCode&IsNhapKho=$isNhapKho');
      var decodedData = jsonDecode(response.body);
      if (decodedData['data'] != null) {
        _data = ScanModel.fromJson(decodedData['data']);
      } else {
        _data = null;
      }

      _isLoading = false;
      _success = decodedData['success'];
      _message = decodedData['message'];
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future postData(ScanModel scanData) async {
    _isLoading = true;
    try {
      var newScanData = scanData;
      newScanData.chuyenId =
          (newScanData.chuyenId == 'null' ? null : newScanData.chuyenId);
      final http.Response response =
          await requestHelper.postData('Mobile/ThongTin', newScanData.toJson());
      var decodedData = jsonDecode(response.body);
      _isLoading = false;
      _success = decodedData['success'];
      _message = decodedData['message'];
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Export data
  Future getExportData(String qrCode) async {
    _isLoading = true;
    _exportData = null;
    try {
      final http.Response response =
          await requestHelper.getData('Mobile/xuat-ke?QrcodeMaKe=$qrCode');
      var decodedData = jsonDecode(response.body);
      if (decodedData['data'] != null) {
        _exportData = ExportModel.fromJson(decodedData['data']);
      } else {
        _exportData = null;
      }

      _isLoading = false;
      _success = decodedData['success'];
      _message = decodedData['message'];
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future postExportData(ExportModel exportScanData) async {
    _isLoading = true;
    try {
      var newScanData = exportScanData.listChiTietKe;
      int newScanDataLength = newScanData.length;
      var exportDataArray = List.generate(
        newScanDataLength,
        (index) => newScanData[index],
      );
      final http.Response response = await requestHelper.postData(
        'Mobile/xuat-ke',
        exportDataArray,
      );
      var decodedData = jsonDecode(response.body);
      _isLoading = false;
      _success = decodedData['success'];
      _message = decodedData['message'];
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // xuất bán lẻ
  Future getDataBanLe(String qrCode, bool isNhapKho) async {
    _isLoading = true;
    _banleData = null;
    try {
      final http.Response response = await requestHelper
          .getData('NhapXuatKhoBanLe?MaCode=$qrCode&IsNhapKho=$isNhapKho');
      var decodedData = jsonDecode(response.body);
      if (decodedData['data'] != null) {
        _banleData = BanLeModel.fromJson(decodedData['data']);
      } else {
        _banleData = null;
      }

      _isLoading = false;
      _success = decodedData['success'];
      _message = decodedData['message'];
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future banLePostData(BanLeModel banLeData) async {
    _isLoading = true;

    try {
      var newScanData = banLeData;
      final http.Response response = await requestHelper.postData(
          'NhapXuatKhoBanLe', newScanData.toJson());
      var decodedData = jsonDecode(response.body);
      _isLoading = false;
      _success = decodedData["success"];
      _message = decodedData['message'];
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future aoNemGetData(qrCode) async {
    _isLoading = true;
    _aoNemData = null;
    try {
      final http.Response response =
          await requestHelper.getData('NhapKhoNemAo?Macode=$qrCode');
      var decodedData = jsonDecode(response.body);
      if (decodedData["data"] != null) {
        _aoNemData = AoNemGheModel.fromJson(decodedData["data"]);
      } else {
        _aoNemData = null;
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

  Future postDataAoNem(AoNemGheModel aoNemData) async {
    _isLoading = true;

    try {
      var newScanData = aoNemData;
      newScanData.hoaChat1Id = null;
      newScanData.hoaChat2Id = null;
      final http.Response response =
          await requestHelper.postData('NhapKhoNemAo', newScanData.toJson());
      var decodedData = jsonDecode(response.body);
      _isLoading = false;
      _success = decodedData["success"];
      _message = decodedData['message'];
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future hoaChatGetData(keyword) async {
    _isLoading = true;
    _hoaChatData = null;
    try {
      final http.Response response =
          await requestHelper.getData('HoaChat?Keyword=$keyword');
      var decodedData = jsonDecode(response.body);
      if (decodedData["data"] != null) {
        _hoaChatData = HoaChatModel.fromJson(decodedData["data"]);
      } else {
        _hoaChatData = null;
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
