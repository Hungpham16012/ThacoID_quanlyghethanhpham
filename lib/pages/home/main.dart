import 'dart:async';
import 'dart:convert';

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static RequestHelper requestHelper = RequestHelper();
  late AppBloc _ab;
  late ScanBloc _sb;
  String _qrData = '';
  final _qrDataController = TextEditingController();
  Timer? _debounce;
  List<String>? _results = [];
  ScanModel? _data;
  List<ScanModel> scannedProducts = [];

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _ab = Provider.of<AppBloc>(context, listen: false);
    _sb = Provider.of<ScanBloc>(context, listen: false);
    // FlutterDataWedge.initScanner(
    //   profileName: 'thghethanhpham',
    //   onScan: (result) {
    //     setState(() {
    //       _qrData = '';
    //       _qrDataController.text = '';
    //       _data = null;
    //       Future.delayed(const Duration(seconds: 1), () {
    //         _qrData = result.data;
    //         _qrDataController.text = result.data;
    //         _onScan(result.data);
    //       });
    //     });
    //   },
    //   onStatusUpdate: (result) {},
    // );
  }

  // Future<void> _scanQRCode() async {
  //   try {
  //     final result = await FlutterBarcodeScanner.scanBarcode(
  //       "#ff6666", // Màu của đường scan
  //       "Hủy", // Văn bản nút hủy
  //       true, // Hiển thị biểu tượng flash
  //       ScanMode.QR, // Chế độ quét (QR hoặc BARCODE)
  //     );

  //     if (!mounted) return;

  //     setState(() {
  //       _qrData = result;
  //       scannedProducts.add(_sb.data!);
  //     });

  //     // Gọi hàm tùy chỉnh xử lý dữ liệu quét
  //     _onScan(_qrData);
  //   } catch (e) {
  //     // Xử lý lỗi nếu có
  //     print("Lỗi khi quét mã QR: $e");
  //   }
  // }

  // Hàm tùy chỉnh để xử lý dữ liệu quét
  _onScan(value) {
    setState(() {
      _loading = true;
    });

    _sb.getData(value, _ab.isNhapKho).then((_) {
      setState(() {
        _qrData = value;

        if (_sb.data == null) {
          _qrData = '';
          _qrDataController.text = '';
          if (_sb.success == false && _sb.message!.isNotEmpty) {
            openSnackBar(context, _sb.message!);
          } else {
            openSnackBar(context, "Không có dữ liệu");
          }
        } else {
          // Add the scanned product to the list

          // Clear the scanned data
          _qrData = '';
          _qrDataController.text = '';
        }

        _loading = false;
        _data = _sb.data;
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

  _onSave() {
    setState(() {
      _loading = true;
    });
    //_data!.chuyenId = _ab.chuyenId;
    // call api
    AppService().checkInternet().then((hasInternet) {
      if (!hasInternet!) {
        openSnackBar(context, 'no internet'.tr());
      } else {
        _sb.postData(_data!).then((_) {
          if (_sb.success) {
            openSnackBar(context, "Lưu thành công");
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
    if (_ab.tenNhomChucNang == null) {
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
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            color: Theme.of(context).colorScheme.onPrimary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  _ab.tenChuyen!,
                  style: Theme.of(context).textTheme.titleLarge,
                ).tr(),
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
                const SizedBox(height: 10),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.camera),
                    label: const Text('Quét mã'))
              ],
            ),
          ),
          const SizedBox(height: 10),
          _loading
              ? LoadingWidget(height: 200)
              : _data == null
                  ? const SizedBox.shrink()
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: scannedProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                showInfoXe(
                                    "Tên", scannedProducts[index].tenDongXe),
                                const SizedBox(height: 10),
                                showInfoXe(
                                    "Model", scannedProducts[index].tenChiTiet),
                                const SizedBox(height: 10),
                                showInfoXe("Loại xe",
                                    scannedProducts[index].tenLoaiXe),
                                const SizedBox(height: 10),
                                if (scannedProducts[index].ngay != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      showInfoXe(
                                        "Ngày",
                                        scannedProducts[index].ngay.toString(),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        },
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
                      Feather.tablet,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    label: Text(
                      _ab.isNhapKho
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
