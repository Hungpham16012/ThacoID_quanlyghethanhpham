import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:install_plugin/install_plugin.dart';

import 'package:http/http.dart' as http;
import '../services/request_helper.dart';

class UpdateChecker {
  static RequestHelper requestHelper = RequestHelper();
  final BuildContext context;
  final String baseApiUrl;
  final String currentVersion;

  UpdateChecker({
    required this.context,
    required this.baseApiUrl,
    required this.currentVersion,
  });

  checkForUpdate() async {
    int statusCode = 200;
    try {
      var values = {
        "maPhienBan": "none",
        "fileName": "none",
        "fileUrl": "none",
        "isCapNhat": false,
        "moTa": "none",
      };

      http.Response response = await requestHelper.getData("PhienBan/KiemTra");
      statusCode = response.statusCode;
      var decodedData = jsonDecode(response.body);
      var data = decodedData["data"];
      var info = data["info"];
      // covert data
      values = {
        "maPhienBan": info["maPhienBan"],
        "fileName": info["fileName"],
        "fileUrl": info["fileUrl"],
        "isCapNhat": data["isCapNhat"],
        "moTa": info["moTa"],
      };
      return values;
    } catch (e) {
      print("Error checking for update: $e");
      return statusCode;
    }
  }

  downloadFileAndInstall(String url, String fileName) async {
    String? downloadId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: 'path/to/downloads',
      showNotification: true,
      openFileFromNotification: true,
    );

    // listen for download progress
    FlutterDownloader.registerCallback((id, status, progress) {
      // Update for the download progress UI
    });

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
    // Install the update using install_plugin_v2
    await InstallPlugin.installApk(
      'path/to/downloads/$fileName',
      appId: 'com.thaco.id.autocom.ghe',
    ).then((value) {
      print(value);
    });
  }
}
