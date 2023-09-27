import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:ghethanhpham_thaco/ultis/common.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;

  setLocalValue('appVersion', version, 'string');

  await FlutterDownloader.initialize(
    ignoreSsl: true,
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
        Locale('ko'),
        Locale('ja'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('vi'),

      // default language
      startLocale: const Locale('vi'),
      useOnlyLangCode: true,
      child: const MyApp(),
    ),
  );
}
