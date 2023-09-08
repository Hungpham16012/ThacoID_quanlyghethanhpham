import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/pages/setting/setting_general.dart';
import 'package:ghethanhpham_thaco/pages/setting/user_ui.dart';
import 'package:ghethanhpham_thaco/ultis/snackbar.dart';
import 'package:ghethanhpham_thaco/ultis/update_checker.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late AppBloc _appBloc;

  String? _version;
  Map<String, dynamic>? values;

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
        callUpdateAction(tmpVal);
      });
    }
  }

  callUpdateAction(values) async {
    if ((values["maPhienBan"] != _appBloc.appVersion) &&
        values["isCapNhat"] == true) {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
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
          )
        ],
      ),
    );
  }
}
