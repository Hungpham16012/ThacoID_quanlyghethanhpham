import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ghethanhpham_thaco/blocs/feature_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/user_bloc.dart';
import 'package:ghethanhpham_thaco/models/chucnang_model.dart';
import 'package:ghethanhpham_thaco/pages/login.dart';
import 'package:ghethanhpham_thaco/pages/setting/setting_nha_may.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';
import 'package:ghethanhpham_thaco/ultis/next_screen.dart';
import 'package:ghethanhpham_thaco/widgets/dialog.dart';
import 'package:ghethanhpham_thaco/widgets/divider.dart';
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
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static RequestHelper requestHelper = RequestHelper();
  late FeatureBloc _featureBloc;
  late AppBloc _appBloc;
  late UserBloc _userBloc;

  String? _version;
  List<ChucNangModel> _listFeatures = [];
  List<SettingOptions> _options = [];
  Map<String, dynamic>? values;
  int? statusCode;
  bool allowRefresh = true;
  late bool _loading = false;

  @override
  void initState() {
    _appBloc = Provider.of<AppBloc>(context, listen: false);
    _featureBloc = Provider.of<FeatureBloc>(context, listen: false);
    _userBloc = Provider.of<UserBloc>(context, listen: false);
    if (_featureBloc.data.isEmpty) {}
    setState(() {
      _loading = true;
    });
    callGetSettingData();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
    super.initState();
  }

  callGetSettingData() {
    // call API
    _featureBloc.getData().then((_) {
      _appBloc.getData().then((_) {
        if (_featureBloc.statusCode == 200) {
          setState(() {});
        }
        setState(() {});
        checkUpdate(_appBloc.appVersion);
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
        // callUpdateAction(tmpVal);
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
      // show a dialog to ask the user to download the update
      // ignore: use_build_context_synchronously
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
          // fileName: values["fileName"],
        );

        // wait for the download to complete
        bool isComplete = false;
        while (!isComplete) {
          List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
          DownloadTask? task =
              tasks?.firstWhere((task) => task.taskId == downloadId);
          if (task?.status == DownloadTaskStatus.complete) {
            isComplete = true;
          }
        }
        // Install the update using install_plugin
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
    // Get the directory where the downloaded files should be saved
    Directory? downloadsDirectory = await getExternalStorageDirectory();
    // Create a new directory called "downloads" within the downloadsDirectory
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
        _listFeatures = _featureBloc.data;
        _options = _featureBloc.data.map((feature) {
          if (_appBloc.tenNhomChucNang != null &&
              _appBloc.tenNhomChucNang == feature.tenNhomChucNang) {}
          return SettingOptions(
            parentName: feature.tenNhomChucNang,
            childId: _appBloc.chuyenId,
          );
        }).toList();
      });
    }
  }

  _renderListFeatures() {
    var values = _listFeatures.isEmpty ? _featureBloc.data : _listFeatures;
    return values.isEmpty
        ? const Text("Nothing")
        : Column(
            children: _listFeatures.map((feature) {
              var parentItem = _options.firstWhere(
                  (name) => name.parentName == feature.tenNhomChucNang);
              var index = _options.indexOf(parentItem);
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
                          feature.tenNhomChucNang,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.7,
                            wordSpacing: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const DividerWidget(),
                        const SizedBox(height: 10),
                        feature.lstChucNangs.isEmpty
                            ? const Text("Không có tuỳ chọn")
                            : SettingNhaMay(
                                listFeatures: feature.lstChucNangs,
                                optionItem: parentItem.childId,
                                onChangeSelect: (value, tenChucNang) {
                                  setState(() {
                                    if (index == 0) {
                                      _options[1] = SettingOptions(
                                        parentName: _options[1].parentName,
                                        childId: null,
                                      );
                                      // save to local value
                                      _appBloc.saveData(
                                        value,
                                        tenChucNang,
                                        feature.tenNhomChucNang,
                                        true,
                                      );
                                    } else {
                                      _options[0] = SettingOptions(
                                        parentName: _options[0].parentName,
                                        childId: null,
                                      );
                                      _appBloc.saveData(
                                        value,
                                        tenChucNang,
                                        feature.tenNhomChucNang,
                                        false,
                                      );
                                    }
                                    parentItem.childId = value;
                                  });
                                },
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
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          _renderListFeatures(),
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
            // child: UserUI(
            //   onlineVersion: _version,
            //   callUpdateAction: callUpdateAction,
            //   values: values,
            // ),
          )
        ],
      ),
    );
  }
}
