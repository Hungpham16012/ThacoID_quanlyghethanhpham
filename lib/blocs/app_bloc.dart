import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/models/settings/chucnang_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc extends ChangeNotifier {
  SharedPreferences? _pref;

  String _apiUrl = "http://10.14.7.70:84";
  String get apiUrl => _apiUrl;

  // String? _chuyenId;
  // String? get chuyenId => _chuyenId;

  String? _tenNhomChucNang;
  String? get tenNhomChucNang => _tenNhomChucNang;

  String? _tenChucNang;
  String? get tenChucNang => _tenChucNang;

  String? _maChucNang;
  String? get maChucNang => _maChucNang;

  bool _isNhapKho = false;
  bool get isNhapKho => _isNhapKho;

  String? _appVersion = '1.0.0';
  String? get appVersion => _appVersion;

  _initPrefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  Future getApiUrl() async {
    await _initPrefs();
    _apiUrl = _pref!.getString('apiUrl') != null
        ? _pref!.getString('apiUrl')!
        : _apiUrl;
    notifyListeners();
  }

  Future saveApiUrl(String url) async {
    await _initPrefs();
    await _pref!.setString('apiUrl', url);
    _apiUrl = url;
    notifyListeners();
  }

  Future saveData(
    String tenChucnang,
    String tenNhomchucnang,
    String maChucnang,
    bool isNhapKho,
    // List? listChuyens,
  ) async {
    await _initPrefs();
    // await _pref!.setString('chuyenId', chuyenId!.toString());
    // await _pref!.setString('tenChuyen', tenchuyen!);
    await _pref!.setString('tenChucNang', tenChucnang);
    await _pref!.setString('tenNhomChucNang', tenNhomchucnang);
    await _pref!.setString('maChucNang', maChucnang);
    await _pref!.setBool('_isNhapKho', isNhapKho);

    _tenNhomChucNang = tenNhomchucnang;
    _maChucNang = maChucnang;
    _tenChucNang = tenChucnang;
    _isNhapKho = isNhapKho;
    notifyListeners();
  }

  Future getData() async {
    await _initPrefs();
    _tenNhomChucNang = _pref!.getString('tenNhomChucNang');
    _tenChucNang = _pref!.getString('tenChucNang');
    _maChucNang = _pref!.getString('maChucNang');
    _isNhapKho = _pref!.getBool('isNhapKho') ?? false;
    _appVersion = _pref!.getString('appVersion');
    // _listChuyens = _pref!.getStringList('lstChuyenIds')!.cast<Chuyen>();
    notifyListeners();
  }

  Future clearData() async {
    _tenNhomChucNang = null;
    _maChucNang = null;
    _isNhapKho = false;
    notifyListeners();
  }
}
