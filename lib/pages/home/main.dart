import 'dart:async';
import 'dart:convert';

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
import 'package:ghethanhpham_thaco/models/scan.dart';
import 'package:ghethanhpham_thaco/services/app_service.dart';
import 'package:ghethanhpham_thaco/services/request_helper.dart';
import 'package:ghethanhpham_thaco/ultis/snackbar.dart';
import 'package:ghethanhpham_thaco/widgets/divider.dart';
import 'package:ghethanhpham_thaco/widgets/loading.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:dropdown_search/dropdown_search.dart';

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
  BanLeModel? _banLeData;
  AoNemGheModel? _aonemData;
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
        _aonemData = null;
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
    _scanBloc.banLeGetData(qrCode, _appBloc.isNhapKho).then((_) {
      setState(() {
        _qrData = qrCode;
        if (_scanBloc.banLeData == null) {
          _qrData = '';
          _qrDataController.text = '';
          if (_scanBloc.success == false && _scanBloc.message!.isNotEmpty) {
            openSnackBar(context, _scanBloc.message!);
          } else {
            openSnackBar(context, "Không có dữ liệu");
          }
        }
        _loading = false;
        _banLeData = _scanBloc.banLeData;
      });
    });
  }

  _onSaveExpostData() {
    setState(() {
      _loading = true;
    });
    // call api
    AppService().checkInternet().then((hasInternet) {
      if (!hasInternet!) {
        openSnackBar(context, 'no internet'.tr());
      } else {
        _scanBloc.banLePostData(_banLeData!).then((_) {
          if (_scanBloc.success) {
            openSnackBar(context, 'Lưu thành công');
          } else {
            openSnackBar(context, 'Lưu thất bại. ${_scanBloc.message}');
          }
        });
      }
      setState(() {
        _aonemData = null;
        _data = null;
        _exportData = null;
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
                  "abc",
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
          DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              disabledItemFn: (String s) => s.startsWith('I'),
            ),
            items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Menu mode",
                hintText: "country in menu mode",
              ),
            ),
            onChanged: print,
          ),
          const SizedBox(height: 5),
          _loading
              ? LoadingWidget(height: 200)
              : _banLeData == null
                  ? const SizedBox.shrink()
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).colorScheme.onPrimary,
                      child: Column(
                        children: [
                          showInfoXe("Tên", _banLeData!.maHangHoa),
                          const SizedBox(height: 10),
                          showInfoXe("Model", _banLeData!.maCode),
                          const SizedBox(height: 10),
                          showInfoXe("Loại xe", _banLeData!.maHangHoa),
                          const SizedBox(height: 10),
                          if (_banLeData!.ngay != null)
                            SizedBox(
                                child: Column(
                              children: [
                                showInfoXe("Ngày", _banLeData!.ngay.toString()),
                                const SizedBox(height: 10),
                              ],
                            )),
                        ],
                      ),
                    ),
          const SizedBox(height: 5),
          _banLeData == null || _loading
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
                    icon: Icon(
                      Feather.tablet,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    label: Text(
                      _banLeData!.nhapXuatKhoId == null
                          ? 'Xuất kho'
                          : 'Hủy xuất kho',
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
