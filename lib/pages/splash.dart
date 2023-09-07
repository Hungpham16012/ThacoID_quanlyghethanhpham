import 'package:flutter/material.dart';

import 'package:ghethanhpham_thaco/config/config.dart';
import 'package:ghethanhpham_thaco/pages/home.dart';
import 'package:ghethanhpham_thaco/pages/login.dart';
import 'package:ghethanhpham_thaco/ultis/next_screen.dart';
import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/user_bloc.dart';
import 'package:ghethanhpham_thaco/config/config.dart';
import 'package:ghethanhpham_thaco/pages/home.dart';
import 'package:ghethanhpham_thaco/pages/login.dart';
import 'package:ghethanhpham_thaco/ultis/next_screen.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import 'package:th_ghe_thanh_pham/blocs/user_bloc.dart';

// import '../blocs/user_bloc.dart';
// import '../blocs/app_bloc.dart';
// import 'home.dart';
//import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future _afterSplash() async {
    final UserBloc ub = context.read<UserBloc>();
    final AppBloc _ab = context.read<AppBloc>();
    Future.delayed(const Duration(seconds: 2)).then((value) async {
      _goToLoginPage();
      _ab.getApiUrl();
      if (ub.isSignedIn) {
        ub.getUserData();
        _ab.getData();
        _goToHomePage();
      } else {
        _goToLoginPage();
      }
    });
  }

  void _goToHomePage() {
    nextScreenReplace(context, const HomePage());
  }

  void _goToLoginPage() {
    nextScreenReplace(context, const LoginPage());
  }

  @override
  void initState() {
    _afterSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Config().appThemeColor,
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Image(
              height: MediaQuery.of(context).size.width - 100,
              width: MediaQuery.of(context).size.width - 100,
              image: const AssetImage(Config.logoIdFull),
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
