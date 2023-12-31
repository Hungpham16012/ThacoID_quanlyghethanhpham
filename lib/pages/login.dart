import 'package:flutter/material.dart';
import 'package:linhkiennhua_thaco/config/config.dart';
import 'package:linhkiennhua_thaco/models/icon.dart';
import 'package:linhkiennhua_thaco/ultis/common.dart';
import 'package:linhkiennhua_thaco/ultis/snackbar.dart';
import 'package:linhkiennhua_thaco/widgets/loading_button.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // late AppBloc _ab;
  // late UserBloc _ub;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var userNameCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  final _btnController = RoundedLoadingButtonController();

  bool offsecureText = true;
  Icon lockIcon = LockIcon().lock;

  final TextEditingController _diaChiApi = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _ab = Provider.of<AppBloc>(context, listen: false);
    // _ub = Provider.of<UserBloc>(context, listen: false);

    setState(() {
      //   _diaChiApi.text = _ab.apiUrl;
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
                // if (validUrl(_diaChiApi.text)) {
                //   _ab.saveApiUrl(_diaChiApi.text);
                //   Navigator.pop(ctx);
                // } else {
                //   // message
                //   openSnackBar(
                //     ctx,
                //     "Địa chỉ url không đúng. Vui lòng nhập lại",
                //   );
                // }
              },
              icon: const Icon(Icons.save),
              label: const Text("Lưu"),
            ),
          ],
        );
      },
    );
  }

  // Future _handleLoginWithUsernamePassword() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   sp.setString('apiUrl', _ab.apiUrl);
  //   if (userNameCtrl.text.isEmpty) {
  //     _btnController.reset();
  //     // ignore: use_build_context_synchronously
  //     openSnackBar(context, 'username is required'.tr());
  //   } else if (passwordCtrl.text.isEmpty) {
  //     _btnController.reset();
  //     // ignore: use_build_context_synchronously
  //     openSnackBar(context, 'password is required'.tr());
  //   } else {
  //     AppService().checkInternet().then((hasInternet) async {
  //       if (!hasInternet!) {
  //         _btnController.reset();
  //         openSnackBar(context, 'no internet'.tr());
  //       } else {
  //         final AuthService asb = context.read<AuthService>();
  //         await asb
  //             .loginWithUsernamePassword(userNameCtrl.text, passwordCtrl.text)
  //             .then((_) {
  //           if (asb.user != null) {
  //             _ub
  //                 .saveUserData(asb.user!)
  //                 .then((_) => _ub.setSignIn())
  //                 .then((_) {
  //               _btnController.success();
  //               nextScreenReplace(context, const HomePage());
  //             });
  //           } else {
  //             if (asb.hasError) {
  //               openSnackBar(context, asb.errorCode);
  //             } else {
  //               openSnackBar(context, 'username or password is incorrect'.tr());
  //             }
  //             _btnController.reset();
  //           }
  //         });
  //       }
  //     });
  //   }
  // }

  _displayLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 20,
        bottom: 50,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 5,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image(
                  height: MediaQuery.of(context).size.width - 150,
                  width: MediaQuery.of(context).size.width - 150,
                  image: const AssetImage(Config.logoId),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      height: 45,
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'enter username'.tr(),
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.person,
                            size: 18,
                          ),
                        ),
                        controller: userNameCtrl,
                        keyboardType: TextInputType.text,
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
                      height: 45,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
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
                            size: 18,
                          ),
                        ),
                        controller: passwordCtrl,
                        obscureText: offsecureText,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    loadingButton(
                      context,
                      _btnController,
                      (),
                      'login',
                      Theme.of(context).primaryColor,
                      Colors.black,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
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
