import 'dart:async';
import 'dart:convert';

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/scan_bloc.dart';
import 'package:ghethanhpham_thaco/models/export_model.dart';
import 'package:ghethanhpham_thaco/models/scan.dart';
import 'package:ghethanhpham_thaco/services/app_service.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';
import 'package:ghethanhpham_thaco/ultis/snackbar.dart';
import 'package:ghethanhpham_thaco/widgets/divider.dart';
import 'package:ghethanhpham_thaco/widgets/loading.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  final String? featureName; // Define the featureName parameter here

  const MainPage({Key? key, this.featureName}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static RequestHelper requestHelper = RequestHelper();
  late AppBloc _appBloc;
  late ScanBloc _scanBloc;
  String _qrData = '';
  final _qrDataController = TextEditingController();
  Timer? _debounce;
  List<String>? _results = [];
  ScanModel? _data;
  ExportModel? _exportData;
  final MobileScannerController scannerController = MobileScannerController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _appBloc = Provider.of<AppBloc>(context, listen: false);
    _scanBloc = Provider.of<ScanBloc>(context, listen: false);
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _getListCode(query);
      });
    } else {
      setState(() {
        _data = null;
        _exportData = null;
      });
    }
  }

  Future<void> _getListCode(String query) async {
    setState(() {
      _loading = true;
    });
    try {
      final http.Response response =
          await requestHelper.getData('Mobile/BarCode?keyword=$query');
      var decodedData = jsonDecode(response.body);
      setState(() {
        _results = decodedData['data'] == null
            ? []
            : List<String>.from(decodedData['data']);
      });
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  // ignore: unused_element
  void _showQRCodeScannerDialog(BuildContext context) {
    final MobileScannerController scannerController = MobileScannerController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scan QR Code'),
          content: MobileScanner(
            controller: scannerController,
            onDetect: (Barcode barcode, MobileScannerArguments? args) {
              // Handle the detected QR code here
              final qrData = barcode.rawValue;
              _onScan(qrData);
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  _onScan(qrCode) {
    setState(() {
      _loading = true;
    });

    if (_appBloc.isNhapKho) {
      _scanBloc.getData(qrCode, _appBloc.isNhapKho).then(
        (_) {
          setState(
            () {
              _qrData = qrCode;
              if (_scanBloc.data == null) {
                // if (_scanBloc.exportData == null) {
                _qrData = '';
                _qrDataController.text = '';
                if (_scanBloc.success == false &&
                    _scanBloc.message!.isNotEmpty) {
                  openSnackBar(context, _scanBloc.message!);
                } else {
                  openSnackBar(context, 'Không có dữ liệu');
                }
              }
              _loading = false;
              _data = _scanBloc.data;
            },
          );
        },
      );
    } else {
      _scanBloc.getExportData(qrCode).then(
        (_) {
          setState(
            () {
              _qrData = qrCode;
              if (_scanBloc.exportData == null) {
                _qrData = '';
                _qrDataController.text = '';
                if (_scanBloc.success == false &&
                    _scanBloc.message!.isNotEmpty) {
                  openSnackBar(context, _scanBloc.message!);
                } else {
                  openSnackBar(context, 'Không có dữ liệu');
                }
              }
              _loading = false;
              _exportData = _scanBloc.exportData;
            },
          );
        },
      );
    }
  }

  _onSave() {
    setState(
      () {
        _loading = true;
      },
    );
    // call api
    AppService().checkInternet().then((hasInternet) {
      if (!hasInternet!) {
        openSnackBar(context, 'no internet'.tr());
      } else {
        if (_appBloc.isNhapKho) {
          _data!.chuyenId = _appBloc.chuyenId!;
          _scanBloc.postData(_data!).then((_) {
            if (_scanBloc.success) {
              openSnackBar(context, 'Lưu thành công');
            } else {
              openSnackBar(context, 'Lưu thất bại. ${_scanBloc.message}');
            }
          });
        } else {
          _scanBloc.postExportData(_exportData!).then((_) {
            if (_scanBloc.success) {
              openSnackBar(context, 'Lưu thành công');
            } else {
              openSnackBar(context, 'Lưu thất bại. ${_scanBloc.message}');
            }
          });
        }
        setState(() {
          _data = null;
          _exportData = null;
          _qrData = '';
          _qrDataController.text = '';
          _loading = false;
        });
      }
    });
  }

  checkNhapXuatKho(isNhapkho) {
    if (isNhapkho) {
      return _data == null
          ? const SizedBox.shrink()
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.onPrimary,
              child: Column(
                children: [
                  showInfoXe('Tên', _data!.tenChiTiet),
                  const SizedBox(height: 10),
                  showInfoXe('Model', _data!.tenDongXe),
                  const SizedBox(height: 10),
                  showInfoXe('Loại xe', _data!.tenLoaiXe),
                  const SizedBox(height: 10),
                  // ignore: unnecessary_null_comparison
                  if (_data!.ngay != null)
                    // if (_data!.ngay != null)
                    SizedBox(
                      child: Column(
                        children: [
                          showInfoXe('Ngày', _data!.ngay.toString()),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                ],
              ),
            );
    } else {
      return _exportData == null
          ? const SizedBox.shrink()
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.onPrimary,
              child: Column(
                children: [
                  // showInfoXe('Tên', _exportData!.tenChiTiet),
                  // const SizedBox(height: 10),
                  showInfoXe('Model', _exportData!.tenDongXe),
                  const SizedBox(height: 10),
                  showInfoXe('Loại xe', _exportData!.tenLoaiXe),
                  const SizedBox(height: 10),
                  // ignore: unnecessary_null_comparison
                  if (_exportData!.ngay != null)
                    // if (_data!.ngay != null)
                    SizedBox(
                      child: Column(
                        children: [
                          showInfoXe('Ngày', _exportData!.ngay.toString()),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                ],
              ),
            );
    }
  }

  checkButton(isNhapKho) {
    if (isNhapKho) {
      return _data == null || _loading
          ? const SizedBox.shrink()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Theme.of(context).colorScheme.onPrimary,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: _onSave,
                icon: Icon(
                  FontAwesomeIcons.tablet,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  _data!.nhapXuatKhoId == null ? 'Nhập kho' : 'Huỷ xác nhận',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                  ),
                ),
              ),
            );
    } else {
      return _exportData == null || _loading
          ? const SizedBox.shrink()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Theme.of(context).colorScheme.onPrimary,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: _onSave,
                icon: Icon(
                  FontAwesomeIcons.tablet,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  _exportData!.isXuat ? 'Hủy xuất kho' : 'Xuất kho',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                  ),
                ),
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_appBloc.tenNhomChucNang == null) {
      return const Center(
          child: Text(
        'Bạn chưa cấu hình để sử dụng.',
        style: TextStyle(fontSize: 20),
      ));
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.onPrimary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _appBloc.tenChuyen!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  const DividerWidget(),
                  const SizedBox(height: 10),
                  EasyAutocomplete(
                    controller: _qrDataController,
                    onChanged: _onSearchChanged,
                    suggestions: _results,
                    onSubmitted: _onScan,
                    decoration: InputDecoration(
                      hintText: 'Enter QR/Bar code',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 10,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.purple,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    suggestionBuilder: (data) {
                      return Container(
                        margin: const EdgeInsets.all(1),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          data,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showQRCodeScannerDialog(context);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text('Quét mã'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            _loading
                ? LoadingWidget(height: 200)
                : checkNhapXuatKho(_appBloc.isNhapKho),
            const SizedBox(height: 10),
            checkButton(_appBloc.isNhapKho),
          ],
        ),
      );
    }
  }
}

// ignore: unused_element

Widget showInfoXe(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      )
    ],
  );
}
