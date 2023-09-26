import 'dart:async';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/scan_bloc.dart';
import 'package:ghethanhpham_thaco/models/aonem.dart';
import 'package:ghethanhpham_thaco/models/banle_model.dart';
import 'package:ghethanhpham_thaco/models/export_model.dart';
import 'package:ghethanhpham_thaco/models/hoachat.dart';
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
  const MainPage({Key? key}) : super(key: key);

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
  BanLeModel? _banLeData;
  AoNemGheModel? _aoNemData;
  final MobileScannerController scannerController = MobileScannerController();
  HoaChatModel? _hoaChatData;
  String? selectedISO;
  String? selectedPoly;
  List<HoaChatModel?> listHoaChatISO1 = [];
  List<HoaChatModel?> listHoaChatPoly1 = [];

  bool _loading = false;
  

  @override
  void initState() {
    super.initState();
    _appBloc = Provider.of<AppBloc>(context, listen: false);
    _scanBloc = Provider.of<ScanBloc>(context, listen: false);

    _scanBloc.getDataHoaChat("ISO").then((_) {
      setState(() {
        listHoaChatISO1 = _scanBloc.listHoaChatISO;
      });
    });
    _scanBloc.getDataHoaChat("POLY").then((_) {
      setState(() {
        listHoaChatPoly1 = _scanBloc.listHoaChatPoly;
      });
    });
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _getListCode(query);
      });
    } else {
      setState(() {
        _aoNemData = null;
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
              _onScanKe(qrData);
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

  _onScanKe(qrCode) {
    setState(() {
      _loading = true;
    });
    _scanBloc.aoNemGetData(qrCode).then((_) {
      setState(() {
        _qrData = qrCode;
        if (_scanBloc.aoNemData == null) {
          _qrData = '';
          _qrDataController.text = '';
          if (_scanBloc.success == false && _scanBloc.message!.isNotEmpty) {
            openSnackBar(context, _scanBloc.message!);
          } else {
            openSnackBar(context, "Không có dữ liệu");
          }
        }
        _loading = false;
        _aoNemData = _scanBloc.aoNemData;
      });
    });
  }

  _onSaveExpostData() {
    setState(() {
      _loading = true;
    });

    _aoNemData?.hoaChat1Id = selectedISO;
    _aoNemData?.hoaChat2Id = selectedPoly;

    AppService().checkInternet().then((hasInternet) {
      if (!hasInternet!) {
        openSnackBar(context, 'no internet'.tr());
      } else {
        if (_aoNemData != null) {
          _scanBloc.postDataNemGhe(_aoNemData!).then((_) {
            if (_scanBloc.success) {
              openSnackBar(context, 'Lưu thành công');
            } else {
              openSnackBar(context, 'Lưu thất bại. ${_scanBloc.message}');
            }
          });
        }
      }
      setState(() {
        _aoNemData = null;
        _banLeData = null;
        _qrData = '';
        _qrDataController.text = '';
        _loading = false;
      });
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
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            color: Theme.of(context).colorScheme.onPrimary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Nhập kho nệm",
                  style: Theme.of(context).textTheme.titleLarge,
                ).tr(),
                const SizedBox(height: 5),
                const DividerWidget(),
                const SizedBox(height: 5),
                EasyAutocomplete(
                    controller: _qrDataController,
                    onChanged: _onSearchChanged,
                    suggestions: _results,
                    onSubmitted: _onScanKe,
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
                          )),
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
                    }),
                const SizedBox(height: 5),
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
          const SizedBox(height: 5),
          Column(
            children: [
              Container(
                width: 400,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2, // Spread radius
                      blurRadius: 4, // Blur radius
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue, fontSize: 16),
                    isDense: true,
                    focusColor: Colors.blue,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 10),
                    hint: const Text('Chọn Hoá Chất POLY'),
                    value: selectedPoly,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPoly = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value:
                            null, // Set the value to null to clear the selection
                        child: const Text('Chọn Hoá Chất POLY'),
                      ),
                      // Add your actual items
                      ...listHoaChatPoly1
                          .map<DropdownMenuItem<String>>(
                            (HoaChatModel? hoaChat) => DropdownMenuItem<String>(
                              value: hoaChat?.id,
                              child: Text(hoaChat?.maHoaChat ?? ""),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: 400,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(8.0), // Border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // Spread radiusrr
                      blurRadius: 4, // Blur radius
                      offset: const Offset(0, 3), // Offset in x and y
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                    hint: const Text('Chọn Hoá Chất ISO'),
                    isDense: true,
                    focusColor: Colors.blue,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    value: selectedISO,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedISO = newValue;
                      });
                    },
                    items: [
                      // Add a "Chọn Hoá Chất ISO" option
                      DropdownMenuItem<String>(
                        value: null,
                        child: const Text('Chọn Hoá Chất ISO'),
                      ),

                      ...listHoaChatISO1
                          .map<DropdownMenuItem<String>>(
                            (HoaChatModel? hoaChat) => DropdownMenuItem<String>(
                              value: hoaChat?.id,
                              child: Text(hoaChat?.maHoaChat ?? ""),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          _loading
              ? LoadingWidget(height: 200)
              : _aoNemData == null
                  ? const SizedBox.shrink()
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).colorScheme.onPrimary,
                      child: Column(
                        children: [
                          showInfoXe("Tên", _aoNemData!.maNemAo),
                          const SizedBox(height: 10),
                          showInfoXe("Model", _aoNemData!.tenNemAo),
                          const SizedBox(height: 10),
                          showInfoXe("Loại xe", _aoNemData!.tenChiTiet),
                          const SizedBox(height: 10),
                          if (_aoNemData!.ngay != null)
                            SizedBox(
                                child: Column(
                              children: [
                                showInfoXe("Ngày", _aoNemData!.ngay.toString()),
                                const SizedBox(height: 10),
                              ],
                            )),
                        ],
                      ),
                    ),
          const SizedBox(height: 5),
          _aoNemData == null || _loading
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
                    onPressed: _onSaveExpostData,
                    icon: const Icon(
                      Feather.tablet,
                      color: Colors.white,
                    ),
                    label: Text(
                      _aoNemData!.ngay == null ? 'Nhập kho' : 'Hủy nhập kho',
                      style: const TextStyle(
                        color: Colors.white,
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
