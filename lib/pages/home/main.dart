import 'dart:async';
import 'dart:convert';

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/feature_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/scan_bloc.dart';
import 'package:ghethanhpham_thaco/config/config.dart';
import 'package:ghethanhpham_thaco/models/products/aonem_model.dart';
import 'package:ghethanhpham_thaco/models/products/banle_model.dart';
import 'package:ghethanhpham_thaco/models/products/export_model.dart';
import 'package:ghethanhpham_thaco/models/products/hoachat_model.dart';
import 'package:ghethanhpham_thaco/models/products/scan.dart';
import 'package:ghethanhpham_thaco/models/settings/chucnang_model.dart';
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
  late FeatureBloc _featureBloc;
  String _qrData = '';
  final _qrDataController = TextEditingController();
  Timer? _debounce;
  List<String>? _results = [];
  ScanModel? _data;
  ExportModel? _exportData;
  BanLeModel? _banLeData;
  AoNemGheModel? _aoNemGheData;
  List<ChuyenModel> listChuyens = [];
  final MobileScannerController scannerController = MobileScannerController();

  HoaChatModel? hoaChat;
  HoaChatModel? hoaChatISO;
  HoaChatModel? hoaChatPoly;
  String? selectedISO;
  String? selectedPoly;
  List<HoaChatModel?> listHoaChatISO1 = [];
  List<HoaChatModel?> listHoaChatPoly1 = [];

  bool _loading = false;

  String? selectedChuyen;

  // const machucnang
  static const xuatTheoKe = 'XUATKHOTHEOKE';
  static const xuatChiTiet = 'XUATKHOCHITIET';
  static const xuatBanLe = 'XUATKHOBANLE';
  static const nhapBanLe = 'NHAPKHOBANLE';
  static const nhapAoGhe = 'NHAPKHOAO';
  static const nhapThanhPham = 'NHAPKHOTHANHPHAM';
  static const nhapNemGhe = 'NHAPKHONEM';

  @override
  void initState() {
    super.initState();
    _appBloc = Provider.of<AppBloc>(context, listen: false);
    _scanBloc = Provider.of<ScanBloc>(context, listen: false);
    _featureBloc = Provider.of<FeatureBloc>(context, listen: false);

    // set giá trị list chuyền
    if (_appBloc.maChucNang == nhapThanhPham) {
      _featureBloc.getData().then((_) {
        setState(() {
          listChuyens = _featureBloc.listChuyenModel;
        });
      });
    }

    // // set giá trị hóa chất
    // _scanBloc.getDataHoaChat("ISO").then((_) {
    //   setState(() {
    //     listHoaChatISO1 = _scanBloc.listHoaChatISO;
    //   });
    // });
    // _scanBloc.getDataHoaChat("POLY").then((_) {
    //   setState(() {
    //     listHoaChatPoly1 = _scanBloc.listHoaChatPoly;
    //   });
    // });
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        switch (_appBloc.maChucNang) {
          case nhapThanhPham || xuatChiTiet:
            _getListCode(
              'Mobile/BarCode?keyword=$query',
              _appBloc.maChucNang,
            );
          case nhapAoGhe || nhapNemGhe:
            _getListCode(
              'Mobile/barCode-nem-ao?keyword=$query',
              _appBloc.maChucNang,
            );
          case xuatBanLe || nhapBanLe:
            _getListCode(
              'NhapXuatKhoBanLe/macode',
              _appBloc.maChucNang,
            );
          case xuatTheoKe:
            _getListCode(
              'Mobile/barCode-ma-ke?keyword=$query',
              _appBloc.maChucNang,
            );
        }
      });
    } else {
      setState(() {
        _data = null;
        _exportData = null;
        _banLeData = null;
        _aoNemGheData = null;
      });
    }
  }

  Future<void> _getListCode(String url, String? maChucNang) async {
    setState(() {
      _loading = true;
    });
    try {
      final http.Response response = await requestHelper.getData(url);
      var decodedData = jsonDecode(response.body);
      if (maChucNang == xuatBanLe || maChucNang == nhapBanLe) {
        List<Map<String, dynamic>> results =
            decodedData['data'] == null ? [] : List.from(decodedData['data']);
        List<String> listMaCode = results.map((item) {
          return item['maCode'] as String;
        }).toList();
        setState(() {
          _results = listMaCode;
        });
      } else {
        setState(() {
          _results = decodedData['data'] == null
              ? []
              : List<String>.from(decodedData['data']);
        });
      }
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

  void _showQRCodeScannerDialogHoaChatISO(BuildContext context) {
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
              onScanHoaChatISO(qrData);
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

  void _showQRCodeScannerDialogHoaChatPoly(BuildContext context) {
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
              onScanHoaChatPoly(qrData);
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

  getDataScan(qrCode, dataScanBloc) {
    _qrData = qrCode;
    if (dataScanBloc == null) {
      _qrData = '';
      _qrDataController.text = '';
      if (_scanBloc.success == false && _scanBloc.message!.isNotEmpty) {
        openSnackBar(context, _scanBloc.message!);
      } else {
        openSnackBar(context, 'Không có dữ liệu');
      }
    }
  }

  statusMessage(status, message) {
    if (status) {
      openSnackBar(context, 'Lưu thành công');
    } else {
      openSnackBar(context, 'Lưu thất bại. $message');
    }
  }

  _onScan(qrCode) {
    setState(() {
      _loading = true;
    });

    switch (_appBloc.maChucNang) {
      case xuatTheoKe:
        _scanBloc.getExportData(qrCode).then(
          (_) {
            setState(
              () {
                getDataScan(qrCode, _scanBloc.exportData);
                _loading = false;
                _exportData = _scanBloc.exportData;
              },
            );
          },
        );
      case xuatChiTiet:
        _scanBloc.getData(qrCode, _appBloc.isNhapKho).then(
          (_) {
            setState(
              () {
                getDataScan(qrCode, _scanBloc.data);
                _loading = false;
                _data = _scanBloc.data;
              },
            );
          },
        );
      case xuatBanLe || nhapBanLe:
        _scanBloc.getDataBanLe(qrCode, _appBloc.isNhapKho).then(
          (_) {
            setState(
              () {
                getDataScan(qrCode, _scanBloc.banLeData);
                _loading = false;
                _banLeData = _scanBloc.banLeData;
              },
            );
          },
        );
      case nhapAoGhe:
        _scanBloc.aoGetData(qrCode).then(
          (_) {
            setState(
              () {
                getDataScan(qrCode, _scanBloc.aoNemData);
                _loading = false;
                _aoNemGheData = _scanBloc.aoNemData;
              },
            );
          },
        );
      case nhapNemGhe:
        _scanBloc.nemGetData(qrCode).then(
          (_) {
            setState(
              () {
                getDataScan(qrCode, _scanBloc.aoNemData);
                _loading = false;
                _aoNemGheData = _scanBloc.aoNemData;
              },
            );
          },
        );
      case nhapThanhPham:
        _scanBloc.getData(qrCode, true).then(
          (_) {
            setState(
              () {
                getDataScan(qrCode, _scanBloc.data);
                _loading = false;
                _data = _scanBloc.data;
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
        switch (_appBloc.maChucNang) {
          case xuatTheoKe:
            if (_exportData != null) {
              _scanBloc.postExportData(_exportData!).then(
                (_) {
                  statusMessage(_scanBloc.success, _scanBloc.message);
                },
              );
            }

            setState(() {
              _exportData = null;
            });

          case xuatChiTiet || nhapThanhPham:
            if (_data != null) {
              _data!.chuyenId = selectedChuyen;
              _scanBloc.postData(_data!).then((_) {
                statusMessage(_scanBloc.success, _scanBloc.message);
              });
            }

            setState(() {
              _data = null;
            });

          case xuatBanLe || nhapBanLe:
            _scanBloc.banLePostData(_banLeData!).then((value) {
              statusMessage(_scanBloc.success, _scanBloc.message);
            });

            setState(() {
              _banLeData = null;
            });
          case nhapAoGhe:
            if (_aoNemGheData != null) {
              _scanBloc.postDataNemGhe(_aoNemGheData!).then(
                (value) {
                  statusMessage(_scanBloc.success, _scanBloc.message);
                },
              );
            }
            setState(
              () {
                _aoNemGheData = null;
              },
            );
          case nhapNemGhe:
            if (_aoNemGheData != null) {
              _aoNemGheData?.hoaChat1Id = hoaChatISO?.id;
              _aoNemGheData?.hoaChat2Id = hoaChatPoly?.id;
              _scanBloc.postDataNemGhe(_aoNemGheData!).then((value) {
                statusMessage(_scanBloc.success, _scanBloc.message);
              });
            }

            setState(
              () {
                _aoNemGheData = null;
              },
            );
        }

        setState(() {
          _qrData = '';
          _qrDataController.text = '';
          _loading = false;
        });
      }
    });
  }

  // kiểm tra case hiển thị thông tin sản phẩm

  checkNhapXuatKho(machucnang) {
    switch (machucnang) {
      case xuatTheoKe:
        return _exportData == null
            ? const SizedBox.shrink()
            : renderThongTinKe();
      case xuatChiTiet || nhapThanhPham:
        return _data == null
            ? const SizedBox.shrink()
            : renderThongTinChiTietKe();
      case xuatBanLe || nhapBanLe:
        return _banLeData == null
            ? const SizedBox.shrink()
            : renderThongTinBanLe();
      case nhapAoGhe || nhapNemGhe:
        return _aoNemGheData == null
            ? const SizedBox.shrink()
            : renderThongTinAoGhe();
    }
  }

  // kiểm tra case hiện button nhập xuất
  checkButton(isNhapKho, machucnang) {
    switch (machucnang) {
      case xuatTheoKe:
        return _exportData == null || _loading
            ? const SizedBox.shrink()
            : renderButtonXuatKhoKe();
      case xuatChiTiet:
        return _data == null || _loading
            ? const SizedBox.shrink()
            : renderButtonNhapXuat(isNhapKho, _data?.nhapXuatKhoId);
      case xuatBanLe || nhapBanLe:
        return _banLeData == null || _loading
            ? const SizedBox.shrink()
            : renderButtonNhapXuat(isNhapKho, _banLeData?.nhapXuatKhoId);
      case nhapAoGhe || nhapNemGhe:
        return _aoNemGheData == null || _loading
            ? const SizedBox.shrink()
            : renderButtonNhapAo(_aoNemGheData?.nhapKhoAoNemId);
      case nhapThanhPham:
        return _data == null || _loading
            ? const SizedBox.shrink()
            : renderButtonNhapXuat(true, _data?.nhapXuatKhoId);
      default:
        return const SizedBox.shrink();
    }
  }

  // render button ở các trường hợp nhập xuất sản phẩm khác nhau

  renderButtonNhapXuat(isNhapkho, nhapxuatkhoId) {
    Color buttonBackgroundColor = isNhapkho
        ? (nhapxuatkhoId == null
            ? Theme.of(context).primaryColor
            : Config().buttonFalse)
        : (nhapxuatkhoId == null
            ? Theme.of(context).primaryColor
            : Config().buttonFalse);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Theme.of(context).colorScheme.onPrimary,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackgroundColor,
        ),
        onPressed: _onSave,
        icon: Icon(
          FontAwesomeIcons.tablet,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        label: Text(
          isNhapkho
              ? (nhapxuatkhoId == null ? "Nhập kho" : "Huỷ nhập kho")
              : (nhapxuatkhoId == null ? "Xuất kho" : "Huỷ xuất kho"),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  renderButtonXuatKhoKe() {
    return Container(
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
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  renderButtonNhapAo(nhapKhoAoNemId) {
    return Container(
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
          nhapKhoAoNemId == null ? "Nhập kho" : "Huỷ nhập kho",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  // render thông tin sản phẩm

  renderThongTinKe() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          showInfo(
            'Mã LOT',
            _exportData!.maLot,
          ),
          showInfo(
            'Model',
            _exportData!.tenDongXe,
          ),
          showInfo(
            'Loại xe',
            _exportData!.tenLoaiXe,
          ),
          // ignore: unnecessary_null_comparison
          if (_exportData?.ngay != null)
            SizedBox(
              child: Column(
                children: [
                  showInfo(
                    'Ngày',
                    _exportData!.ngay.toString(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }

  renderThongTinChiTietKe() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          showInfo('Tên', _data!.tenChiTiet),
          showInfo('Model', _data!.tenDongXe),
          showInfo('Loại xe', _data!.tenLoaiXe),
          // ignore: unnecessary_null_comparison
          if (_data!.ngay != null)
            // if (_data!.ngay != null)
            SizedBox(
              child: Column(
                children: [
                  showInfo('Ngày', _data!.ngay.toString()),
                  const SizedBox(height: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }

  renderThongTinBanLe() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          showInfo('Tên hàng hóa', _banLeData!.tenHangHoa),
          showInfo('Model', _banLeData!.tenDongXe),
          showInfo('Loại xe', _banLeData!.tenLoaiXe),
          // ignore: unnecessary_null_comparison
          if (_banLeData!.ngay != null)
            SizedBox(
              child: Column(
                children: [
                  showInfo('Ngày', _banLeData!.ngay.toString()),
                  const SizedBox(height: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }

  renderThongTinAoGhe() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          showInfo('Tên nệm áo', _aoNemGheData!.tenNemAo),
          showInfo('Model', _aoNemGheData!.tenDongXe),
          showInfo('Loại xe', _aoNemGheData!.tenLoaiXe),
          // ignore: unnecessary_null_comparison
          if (_aoNemGheData!.ngay != null)
            SizedBox(
              child: Column(
                children: [
                  showInfo('Ngày', _aoNemGheData!.ngay.toString()),
                  const SizedBox(height: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // render dropdown chọn chuyền

  dropdownChuyen(listChuyen) {
    return Container(
      width: 400,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: Config().selected),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            fontSize: 16,
            color: selectedChuyen != null
                ? Config().selected
                : Config().defaultSelected,
          ),
          isDense: true,
          focusColor: Config().defaultSelected,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(8),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          hint: Text(
            'Chọn Chuyền',
            style: TextStyle(
              color: Config().appThemeColor,
            ),
          ),
          value: selectedChuyen,
          onChanged: (String? newValue) {
            setState(() {
              selectedChuyen = newValue;
            });
          },
          items: listChuyen
              .map<DropdownMenuItem<String>>(
                (ChuyenModel? chuyen) => DropdownMenuItem<String>(
                  value: chuyen?.chuyenId,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 180, // Adjust this value as needed
                      ),
                      child: Text(
                        chuyen?.tenChuyen ?? "",
                        style: TextStyle(
                          overflow: TextOverflow.visible,
                          fontSize: 15,
                          color: selectedChuyen == chuyen?.chuyenId
                              ? Config().selected
                              : Config().defaultSelected,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // render dropdown chọn hóa chất

  hoaChatWidget() {
    return Column(
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
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Config().selected),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                fontSize: 16,
                color: selectedPoly != null
                    ? Config().selected
                    : Config()
                        .defaultSelected, // Change text color when selected
              ),
              hint: const Text('Chọn Hoá Chất Poly'),
              isDense: true,
              focusColor: Config().defaultSelected,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              value: selectedPoly,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPoly = newValue;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text('Chọn Hoá Chất Poly',
                      style: TextStyle(color: Config().defaultSelected)),
                ),
                ...listHoaChatPoly1
                    .map<DropdownMenuItem<String>>(
                      (HoaChatModel? hoaChat) => DropdownMenuItem<String>(
                        value: hoaChat?.id,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 200, // Adjust this value as needed
                          ),
                          child: Text(
                            hoaChat?.maHoaChat ?? "",
                            style: TextStyle(
                              overflow: TextOverflow.visible,
                              fontSize: 15,
                              color: selectedPoly == hoaChat?.id
                                  ? Config().selected
                                  : Config().defaultSelected,
                            ),
                          ),
                        ),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Config().selected),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                fontSize: 16,
                color: selectedISO != null
                    ? Config().selected
                    : Config()
                        .defaultSelected, // Change text color when selected
              ),
              hint: const Text('Chọn Hoá Chất ISO'),
              isDense: true,
              focusColor: Config().defaultSelected,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              value: selectedISO,
              onChanged: (String? newValue) {
                setState(() {
                  selectedISO = newValue;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text('Chọn Hoá Chất ISO',
                      style: TextStyle(color: Config().defaultSelected)),
                ),
                ...listHoaChatISO1
                    .map<DropdownMenuItem<String>>(
                      (HoaChatModel? hoaChat) => DropdownMenuItem<String>(
                        value: hoaChat?.id,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 200, // Adjust this value as needed
                          ),
                          child: Text(
                            hoaChat?.maHoaChat ?? "",
                            style: TextStyle(
                              overflow: TextOverflow.visible,
                              fontSize: 15,
                              color: selectedISO == hoaChat?.id
                                  ? Config().selected
                                  : Config().defaultSelected,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
        const DividerWidget(),
      ],
    );
  }

  void removeHoaChatISO(hoaChat) {
    setState(() {
      hoaChatISO = null;
    });
  }

  void removeoaChatPoly(hoaChat) {
    setState(() {
      hoaChatPoly = null;
    });
  }

  // render scan chọn hóa chất
  scanHoaChat() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Hóa Chất',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 3),
          const DividerWidget(),
          const SizedBox(height: 5),
          // khung text hoá chất
          Container(
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hoaChatISO == null
                            ? 'Hóa chất ISO:'
                            : 'Hóa chất ISO: ${hoaChatISO?.maHoaChat}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showQRCodeScannerDialogHoaChatISO(context);
                      },
                      icon: const Icon(
                        Icons.qr_code_2_rounded,
                        color: Colors.black,
                      ),
                      label: const Text(''),
                      style: ButtonStyle(
                        elevation:
                            MaterialStateProperty.all<double>(0), // Xóa đổ bóng
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        removeHoaChatISO(hoaChatISO);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      label: const Text(''),
                      style: ButtonStyle(
                        elevation:
                            MaterialStateProperty.all<double>(0), // Xóa đổ bóng
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hoaChatPoly == null
                            ? 'Hóa chất Poly:'
                            : 'Hóa chất Poly: ${hoaChatPoly?.maHoaChat}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showQRCodeScannerDialogHoaChatPoly(context);
                      },
                      icon: const Icon(
                        Icons.qr_code_2_rounded,
                        color: Colors.black,
                      ),
                      label: const Text(''),
                      style: ButtonStyle(
                        elevation:
                            MaterialStateProperty.all<double>(0), // Xóa đổ bóng
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        removeoaChatPoly(hoaChatPoly);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      label: const Text(''),
                      style: ButtonStyle(
                        elevation:
                            MaterialStateProperty.all<double>(0), // Xóa đổ bóng
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // scan qrcode hóa chất
  onScanHoaChatISO(qrHoaChat) {
    _scanBloc.hoaChatGetData(qrHoaChat, 'ISO').then(
      (_) {
        setState(
          () {
            getDataScan(qrHoaChat, _scanBloc.hoaChatModel);
            _loading = false;
            hoaChatISO = _scanBloc.hoaChatModel;
          },
        );
      },
    );
  }

  onScanHoaChatPoly(qrHoaChat) {
    _scanBloc.hoaChatGetData(qrHoaChat, 'Poly').then(
      (_) {
        setState(
          () {
            getDataScan(qrHoaChat, _scanBloc.hoaChatModel);
            _loading = false;
            hoaChatPoly = _scanBloc.hoaChatModel;
          },
        );
      },
    );
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
            const SizedBox(height: 8),
            // quét hóa chất khi machucnang = nhapNemGhe
            _appBloc.maChucNang == nhapNemGhe
                ? scanHoaChat()
                : const SizedBox.shrink(),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.onPrimary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _appBloc.tenChucNang!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  const DividerWidget(),
                  const SizedBox(height: 10),

                  // hiển thị dropdown chuyền
                  listChuyens.isEmpty
                      ? const SizedBox.shrink()
                      : dropdownChuyen(listChuyens),
                  // const SizedBox(height: 10),
                  // const DividerWidget(),
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
                    icon: const Icon(Icons.qr_code_2_rounded),
                    label: const Text('Quét mã'),
                  )
                ],
              ),
            ),
            // render thông tin data sau khi quét
            const SizedBox(
              height: 8,
            ),
            _loading
                ? LoadingWidget(height: 200)
                : checkNhapXuatKho(_appBloc.maChucNang) ??
                    const SizedBox.shrink(),
            const SizedBox(height: 5),
            checkButton(_appBloc.isNhapKho, _appBloc.maChucNang) ??
                const SizedBox.shrink(),
          ],
        ),
      );
    }
  }
}

// ignore: unused_element
Widget showInfo(String title, String value) {
  return Column(
    children: [
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          )
        ],
      ),
    ],
  );
}
