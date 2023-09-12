import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/chucnang_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/history_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/scan_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/theme_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/user_bloc.dart';
import 'package:ghethanhpham_thaco/models/theme.dart';
import 'package:ghethanhpham_thaco/pages/splash.dart';
import 'package:ghethanhpham_thaco/services/auth_service.dart';
// import 'package:wakelock/wakelock.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wakelock.enable();
    return ChangeNotifierProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
      child: Consumer<ThemeBloc>(
        builder: (_, mode, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AppBloc>(
                create: (context) => AppBloc(),
              ),
              ChangeNotifierProvider<UserBloc>(
                create: (context) => UserBloc(),
              ),
              ChangeNotifierProvider<AuthService>(
                create: (context) => AuthService(),
              ),
              ChangeNotifierProvider<ChucNangBloc>(
                create: (context) => ChucNangBloc(),
              ),
              ChangeNotifierProvider<ScanBloc>(
                create: (context) => ScanBloc(),
              ),
              ChangeNotifierProvider<HistoryBloc>(
                create: (context) => HistoryBloc(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              locale: context.locale,
              theme: ThemeModel().lightTheme,
              darkTheme: ThemeModel().darkTheme,
              themeMode:
                  mode.darkTheme == true ? ThemeMode.dark : ThemeMode.light,
              home: const SplashPage(),
            ),
          );
        },
      ),
    );
  }
}
