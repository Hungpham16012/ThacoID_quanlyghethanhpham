import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ghethanhpham_thaco/blocs/feature_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/user_bloc.dart';
import 'package:ghethanhpham_thaco/models/chucnang_model.dart';
import 'package:ghethanhpham_thaco/pages/home.dart';
import 'package:ghethanhpham_thaco/pages/home/main.dart';
import 'package:ghethanhpham_thaco/pages/login.dart';
import 'package:ghethanhpham_thaco/pages/setting/setting_nha_may.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';
import 'package:ghethanhpham_thaco/ultis/next_screen.dart';
import 'package:ghethanhpham_thaco/widgets/dialog.dart';
import 'package:ghethanhpham_thaco/widgets/loading.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/pages/setting/setting_general.dart';
import 'package:ghethanhpham_thaco/pages/setting/user_ui.dart';
import 'package:ghethanhpham_thaco/ultis/snackbar.dart';
import 'package:ghethanhpham_thaco/ultis/update_checker.dart';
import 'package:provider/provider.dart';

class SettingOptions {
  String parentName;
  String? childId;

  SettingOptions({
    required this.parentName,
    this.childId,
  });
}

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static RequestHelper requestHelper = RequestHelper();
  late FeatureBloc _featureBloc;
  late AppBloc _appBloc;
  late UserBloc _userBloc;

  String? _version;
  List<ChucNangModel> _listGroupFeatures = [];
  List<SettingOptions> _options = [];
  Map<String, dynamic>? values;
  int? statusCode;
  bool allowRefresh = true;
  late bool _loading = false;

  @override
  void initState() {
    super.initState();
    _appBloc = Provider.of<AppBloc>(context, listen: false);
    _featureBloc = Provider.of<FeatureBloc>(context, listen: false);
    _userBloc = Provider.of<UserBloc>(context, listen: false);
    setState(() {
      _loading = true;
    });
    callGetSettingData();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
  }

  callGetSettingData() {
    // call API
    _featureBloc.getData().then((_) {
      _appBloc.getData().then((_) {
        if (_featureBloc.statusCode == 200) {
          setState(() {
            _loading = false;
            _listGroupFeatures.addAll(_featureBloc.data);
            _options = _featureBloc.data.map((feature) {
              if (_appBloc.tenNhomChucNang != null &&
                  _appBloc.tenNhomChucNang == feature.tenNhomChucNang) {}
              return SettingOptions(
                parentName: feature.tenNhomChucNang,
                childId: _appBloc.maChucNang,
              );
            }).toList();
          });
        }
        setState(() {
          _loading = false;
        });
        checkUpdate(_appBloc.appVersion ?? "1.0.3");
        statusCode = _featureBloc.statusCode;
        Future.delayed(const Duration(seconds: 2), () async {
          if (_featureBloc.statusCode == 401) {
            signOutAction();
          }
        });
      });
    });
  }

  void signOutAction() async {
    await _userBloc.userSignout().then((_) {
      _appBloc.clearData().then((_) {
        nextScreenCloseOthers(
          context,
          const LoginPage(),
        );
      });
    });
  }

  callRefreshToken() {
    // call to refresh token
    openSnackBar(
      context,
      "Hết phiên làm việc cũ. Chúng tôi sẽ cập nhật ngay bây giờ",
    );

    showDiaLogItem(
      context: context,
      actions: () async {
        var newToken = await requestHelper.refreshTokenAction({
          "token": _userBloc.token,
          "refreshToken": _userBloc.refreshToken,
        });
        // set token Value
        _userBloc.refreshTokenValue(newToken);
        allowRefresh = false;
      },
      cancelActions: () {
        // logout
        signOutAction();
      },
      title: "Hết phiên làm việc.",
      content: "Bạn có muốn tiếp tục làm việc không?",
    );
  }

  checkUpdate(version) async {
    var checkVersion = UpdateChecker(
      context: context,
      baseApiUrl: _appBloc.apiUrl,
      currentVersion: version,
    );
    var tmpVal = await checkVersion.checkForUpdate();
    if (tmpVal is! int) {
      setState(() {
        _version = tmpVal["maPhienBan"];
        values = tmpVal;
      });
    }
  }

  static void downloadCallback(
    String id,
    int status,
    int progress,
  ) {
    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  callUpdateAction(values) async {
    if ((values["maPhienBan"] != _appBloc.appVersion) && values["isCapNhat"]) {
      bool shouldUpdate = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Cập nhật"),
            content: const Text(
              "Ứng dụng đã có phiên bản mới. Bạn có muốn tải về không?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Huỷ"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Tải về và cài đặt"),
              ),
            ],
          );
        },
      );
      if (shouldUpdate) {
        await createDownloadDirectory();
        Directory? downloadsDirectory = await getExternalStorageDirectory();
        List<String> tmpArr = values["fileUrl"].split('/');
        // Get the file path
        final String filePath =
            '${downloadsDirectory!.path}/Download/${tmpArr.last}';

        // Check if the file exists
        final bool fileExists = File(filePath).existsSync();

        // Delete the file if it exists
        if (fileExists) {
          File(filePath).deleteSync();
        }

        String? downloadId = await FlutterDownloader.enqueue(
          url: '${_appBloc.apiUrl}/${values["fileUrl"]}',
          savedDir: '${downloadsDirectory.path}/Download',
          showNotification: true,
          openFileFromNotification: true,
          fileName: values["fileName"],
        );

        bool isComplete = false;
        while (!isComplete) {
          List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
          DownloadTask? task =
              tasks?.firstWhere((task) => task.taskId == downloadId);
          if (task?.status == DownloadTaskStatus.complete) {
            isComplete = true;
          }
        }

        await InstallPlugin.installApk(
          '${downloadsDirectory.path}/Download/${tmpArr.last}',
          appId: 'com.thaco.id.autocom.ghe',
        ).then((value) {
          if (value == 'Success') {
            openSnackBar(context, "Tải xuống thành công");
          }
        });
      }
    }
  }

  createDownloadDirectory() async {
    Directory? downloadsDirectory = await getExternalStorageDirectory();
    String downloadsPath = "${downloadsDirectory!.path}/Download";
    Directory downloadsDir = Directory(downloadsPath);
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call the action when the screen becomes active after clicking on a tab menu
    if (_featureBloc.data.isNotEmpty) {
      setState(() {
        _listGroupFeatures = _featureBloc.data;
        _options = _featureBloc.data.map((feature) {
          if (_appBloc.tenNhomChucNang != null &&
              _appBloc.tenNhomChucNang == feature.tenNhomChucNang) {}
          return SettingOptions(
            parentName: feature.tenNhomChucNang,
            childId: _appBloc.maChucNang,
          );
        }).toList();
      });
    }
  }

  _renderListFeatures() {
    var values =
        _listGroupFeatures.isEmpty ? _featureBloc.data : _listGroupFeatures;

    return values.isEmpty
        ? const Text('Nothing')
        : Column(
            children: _featureBloc.data.map((group) {
              var parentItem = _options.firstWhere(
                  (name) => name.parentName == group.tenNhomChucNang);
              var index = _options.indexOf(parentItem);
              var tenNhomChucNang = group.tenNhomChucNang;
              return Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Column(
                      children: [
                        Text(
                          group.tenNhomChucNang,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        group.lstChucNangs.isEmpty
                            ? const Text("Không có tuỳ chọn")
                            : Column(
                                children: group.lstChucNangs.map((feature) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Feather.archive),
                                        title: Text(feature.tenChucNang),
                                        trailing: Radio<String>(
                                          value: feature.selected ??
                                              '', // Use the selected value from your model
                                          groupValue: feature
                                              .tenChucNang, // Group by the group's name
                                          onChanged: (String? value) {
                                            // Update the selected value in your data model
                                            setState(
                                              () {
                                                feature.selected = value!;
                                                _appBloc.saveData(
                                                  feature.tenChucNang,
                                                  tenNhomChucNang,
                                                  feature.maChucNang,
                                                  feature.isNhapKho,
                                                );
                                              },
                                            );
                                            // // Navigate to the homepage or perform other actions based on the selected value
                                            // Navigator.pushReplacement(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         const MainPage(),
                                            //   ),
                                            // );
                                          },
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      // Add additional logic or widgets as needed
                                    ],
                                  );
                                }).toList(),
                              ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              _loading ? LoadingWidget(height: 350) : _renderListFeatures(),
              const SizedBox(
                height: 15,
              ),
              // Setting for the application
              const SettingGeneral(),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                child: UserUI(
                  onlineVersion: _version,
                  callUpdateAction: callUpdateAction,
                  values: values,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
