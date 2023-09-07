import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ghethanhpham_thaco/services/request_helper.dart';
import '../models/user.dart';

class UserBloc extends ChangeNotifier {
  static RequestHelper requestHelper = RequestHelper();

  UserBloc() {
    checkSignIn();
  }

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  String? _fullName;
  String? get name => _fullName;

  String? _id;
  String? get id => _id;

  String? _email;
  String? get email => _email;

  String? _expires;
  String? get expires => _expires;

  bool _mustChangePass = false;
  bool get mustChangePass => _mustChangePass;

  String? _token;
  String? get token => _token;

  String? _refreshToken;
  String? get refreshToken => _refreshToken;
// Hàm lưu dữ liệu người dùng, dùng spf để lấy ra instance của UserModel sau đó
// gán vào getter của thông tin người dùng, sau đó gán vào lại _user model
  Future saveUserData(UserModel userModel) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('id', userModel.id!);
    await sp.setString('fullName', userModel.fullName!);
    await sp.setString('email', userModel.email!);
    await sp.setBool('mustChangePass', userModel.mustChangePass!);
    await sp.setString('token', userModel.token!);
    await sp.setString('refreshToken', userModel.refreshToken!);

    _id = userModel.id;
    _fullName = userModel.fullName;
    _email = userModel.email;
    _mustChangePass = userModel.mustChangePass!;
    _token = userModel.token;
    _refreshToken = userModel.refreshToken;
    notifyListeners();
  }

// Hàm lấy dữ liệu của người dùng thông qua phương thức get của lớp SPF
  Future getUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _id = sp.getString('id');
    _fullName = sp.getString('fullName');
    _email = sp.getString('email');
    _expires = sp.getString('expires');
    _mustChangePass = sp.getBool('mustChangePass')!;
    _token = sp.getString('token');
    _refreshToken = sp.getString('refreshToken');
    notifyListeners();
  }

  Future refreshTokenValue(data) async {
    _token = data["token"];
    _refreshToken = data["refreshToken"];
    notifyListeners();
  }

// đặt trạng thái đăng nhập là đã đăng nhập
  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }

// kiểm tra trạng thái đăng nhập
  Future checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }

// Ham Dang xuat
  Future userSignout() async {
    await clearAllUserData().then((_) {
      _isSignedIn = false;
      _expires = null;
      _fullName = null;
      _email = null;
      _token = null;
      _refreshToken = null;
      _id = null;
      notifyListeners();
    });
  }

// Xoa toan bo du lieu nguoi dung
  Future clearAllUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}
