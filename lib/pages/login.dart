import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/user_bloc.dart';
import 'package:ghethanhpham_thaco/config/config.dart';
import 'package:ghethanhpham_thaco/models/icon.dart';
import 'package:ghethanhpham_thaco/pages/home.dart';
import 'package:ghethanhpham_thaco/services/app_service.dart';
import 'package:ghethanhpham_thaco/services/auth_service.dart';
import 'package:ghethanhpham_thaco/ultis/common.dart';
import 'package:ghethanhpham_thaco/ultis/next_screen.dart';
import 'package:ghethanhpham_thaco/ultis/snackbar.dart';
import 'package:ghethanhpham_thaco/widgets/loading_button.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color usernameBorderColor = Colors.grey;
  Color passwordBorderColor = Colors.grey;
  var formKey = GlobalKey<FormState>();
  Icon lockIcon = LockIcon().lock;
  bool offsecureText = true;
  var passwordCtrl = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var userNameCtrl = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  late AppBloc _ab;
  final _btnController = RoundedLoadingButtonController();
  final TextEditingController _diaChiApi = TextEditingController();
  late UserBloc _ub;

  @override
  void initState() {
    super.initState();
    _ab = Provider.of<AppBloc>(context, listen: false);
    _ub = Provider.of<UserBloc>(context, listen: false);

    setState(() {
      _diaChiApi.text = _ab.apiUrl;
    });
  }

  void _onlockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        lockIcon = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = LockIcon().lock;
      });
    }
  }

  void _settingApi() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Cấu hình kết nối"),
          content: TextField(
            keyboardType: TextInputType.url,
            controller: _diaChiApi,
            decoration: const InputDecoration(
              hintText: "Nhập địa chỉ API được cung cấp...",
            ),
          ),
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.onSecondary,
              ),
              onPressed: () {
                Navigator.pop(ctx);
              },
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.black,
              ),
              label: const Text(
                "Thoát",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(ctx).primaryColor,
              ),
              onPressed: () {
                if (validUrl(_diaChiApi.text)) {
                  _ab.saveApiUrl(_diaChiApi.text);
                  Navigator.pop(ctx);
                } else {
                  // message
                  openSnackBar(
                    ctx,
                    "Địa chỉ url không đúng. Vui lòng nhập lại",
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: const Text("Lưu"),
            ),
          ],
        );
      },
    );
  }

  Future _handleLoginWithUsernamePassword() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('apiUrl', _ab.apiUrl);
    if (userNameCtrl.text.isEmpty) {
      _btnController.reset();
      // ignore: use_build_context_synchronously
      openSnackBar(context, 'username is required'.tr());
    } else if (passwordCtrl.text.isEmpty) {
      _btnController.reset();
      // ignore: use_build_context_synchronously
      openSnackBar(context, 'password is required'.tr());
    } else {
      AppService().checkInternet().then((hasInternet) async {
        if (!hasInternet!) {
          _btnController.reset();
          openSnackBar(context, 'no internet'.tr());
        } else {
          final AuthService asb = context.read<AuthService>();
          await asb
              .loginWithUsernamePassword(userNameCtrl.text, passwordCtrl.text)
              .then((_) {
            if (asb.user != null) {
              _ub
                  .saveUserData(asb.user!)
                  .then((_) => _ub.setSignIn())
                  .then((_) {
                _btnController.success();
                nextScreenReplace(context, const HomePage());
              });
            } else {
              if (asb.hasError) {
                openSnackBar(context, asb.errorCode);
              } else {
                openSnackBar(context, 'username or password is incorrect'.tr());
              }
              _btnController.reset();
            }
          });
        }
      });
    }
  }

  _displayLoginForm() {
    return Scaffold(
      backgroundColor: Config().buttonColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 30,
          bottom: 30,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 0,
              child: SizedBox(
                height: 40,
                width: 40,
                child: InkWell(
                  onTap: () {
                    _settingApi();
                  },
                  child: const Icon(
                    FontAwesomeIcons.cloud,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(
                  height: MediaQuery.of(context).size.width - 170,
                  // height: 200,
                  width: MediaQuery.of(context).size.width - 100,
                  image: const AssetImage(Config.logoId),
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                const Text(
                  'XIN CHÀO!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ĐĂNG NHẬP',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Config().appThemeColor,
                        ),
                      ),
                      const Text(
                        'username',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          wordSpacing: 1,
                          letterSpacing: -0.7,
                          color: Colors.white,
                        ),
                      ).tr(),
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: usernameBorderColor,
                            width: 2.0,
                          ),
                        ),
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            setState(() {
                              usernameBorderColor = hasFocus
                                  ? Config().appThemeColor
                                  : Colors.grey; //
                              passwordBorderColor =
                                  hasFocus ? Colors.grey : passwordBorderColor;
                            });
                          },
                          child: TextFormField(
                            focusNode: usernameFocus,
                            decoration: InputDecoration(
                              hintText: 'enter username'.tr(),
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              prefixIcon: const Icon(
                                Icons.person_2,
                                size: 23,
                              ),
                            ),
                            controller: userNameCtrl,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      const Text(
                        'password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          wordSpacing: 1,
                          letterSpacing: -0.7,
                          color: Colors.white,
                        ),
                      ).tr(),
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: passwordBorderColor,
                            width: 2.0,
                          ),
                        ),
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            setState(() {
                              usernameBorderColor = hasFocus
                                  ? Config().appThemeColor
                                  : Colors.blue;
                              passwordBorderColor = hasFocus
                                  ? Colors.blue // d
                                  : passwordBorderColor;
                            });
                          },
                          child: TextFormField(
                            focusNode: passwordFocus,
                            decoration: InputDecoration(
                              hintText: 'enter password'.tr(),
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: lockIcon,
                                onPressed: () => _onlockPressed(),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                size: 23,
                              ),
                            ),
                            controller: passwordCtrl,
                            obscureText: offsecureText,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      loadingButton(
                        context,
                        _btnController,
                        _handleLoginWithUsernamePassword,
                        'login',
                        Theme.of(context).primaryColor,
                        Colors.white,
                      ),
                      const SizedBox(
                        height: 35,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Bản quyền thuộc về THACO INDUSTRIES @ 2023',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey,
      body: _displayLoginForm(),
    );
  }
}
