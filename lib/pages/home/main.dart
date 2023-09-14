import 'dart:async';
import 'dart:convert';

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/scan_bloc.dart';
import 'package:ghethanhpham_thaco/models/scan.dart';
import 'package:ghethanhpham_thaco/services/app_service.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';
import 'package:ghethanhpham_thaco/ultis/snackbar.dart';
import 'package:ghethanhpham_thaco/widgets/divider.dart';
import 'package:ghethanhpham_thaco/widgets/loading.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

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
  List<ScanModel> listScannedProduct = [];

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _appBloc = Provider.of<AppBloc>(context, listen: false);
    _scanBloc = Provider.of<ScanBloc>(context, listen: false);
  }

  Future<void> _scanQRCode() async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color of the scan line
        'Hủy', // text button
        true, // show flash icon
        ScanMode.QR, // scan feature (QR or BARCODE)
      );

      if (!mounted) return;

      setState(() {
        _qrData = result;
      });

      // call resolve scan data function
      _onScan(_qrData);
    } catch (e) {
      // print error
      print("Lỗi khi quét mã QR: $e");
    }
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
        _results = decodedData["data"] == null
            ? []
            : List<String>.from(decodedData["data"]);
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

  _onScan(qrCode) {
    setState(() {
      _loading = true;
    });

    _scanBloc.getData(qrCode, _appBloc.isNhapKho).then(
      (_) {
        setState(
          () {
            _qrData = _qrData;
            if (_scanBloc.data == null) {
              _qrData = '';
              _qrDataController.text = '';
              if (_scanBloc.success == false && _scanBloc.message!.isNotEmpty) {
                openSnackBar(context, _scanBloc.message!);
              } else {
                openSnackBar(context, "Không có dữ liệu");
              }
            }
            _loading = false;
            _data = _scanBloc.data;
          },
        );
      },
    );
  }

  _onSave() {
    setState(
      () {
        _loading = true;
      },
    );
    _data!.chuyenId = _appBloc.chuyenId!;
    // call api
    AppService().checkInternet().then((hasInternet) {
      if (!hasInternet!) {
        openSnackBar(context, 'no internet'.tr());
      } else {
        _scanBloc.postData(_data!).then((_) {
          if (_scanBloc.success) {
            openSnackBar(context, 'Lưu thành công');
          } else {
            openSnackBar(context, "Lưu thất bại");
          }
          setState(() {
            _data = null;
            _qrData = '';
            _qrDataController.text = '';
            _loading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_appBloc.tenNhomChucNang == null) {
      return const Center(
          child: Text(
        "Bạn chưa cấu hình để sử dụng.",
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
                    onPressed: _scanQRCode,
                    icon: const Icon(Icons.camera),
                    label: const Text('Quét mã'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _loading
                ? LoadingWidget(height: 200)
                : _data == null
                    ? const SizedBox.shrink()
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        color: Theme.of(context).colorScheme.onPrimary,
                        child: Column(
                          children: [
                            showInfoXe("Tên", _data!.tenChiTiet),
                            const SizedBox(height: 10),
                            showInfoXe("Model", _data!.tenDongXe),
                            const SizedBox(height: 10),
                            showInfoXe("Loại xe", _data!.tenLoaiXe),
                            const SizedBox(height: 10),
                            // ignore: unnecessary_null_comparison
                            if (_data!.ngay != null)
                              // if (_data!.ngay != null)
                              SizedBox(
                                child: Column(
                                  children: [
                                    showInfoXe("Ngày", _data!.ngay.toString()),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
            const SizedBox(height: 10),
            _data == null || _loading
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
                        _appBloc.isNhapKho
                            ? (_data!.nhapXuatKhoId == null
                                ? "Nhập kho"
                                : "Huỷ xác nhận")
                            : (_data!.nhapXuatKhoId == null
                                ? "Xuất kho"
                                : "Huỷ xác nhận"),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
          ],
        ),
      );
    }
  }
}

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
