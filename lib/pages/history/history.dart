import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/history_bloc.dart';
import 'package:ghethanhpham_thaco/models/history.dart';
import 'package:ghethanhpham_thaco/pages/history/nhap_kho.dart';
import 'package:ghethanhpham_thaco/pages/history/xuat_kho.dart';
import 'package:ghethanhpham_thaco/services/app_service.dart';
import 'package:ghethanhpham_thaco/ultis/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late AppBloc _ab;
  late HistoryBloc _hb;
  bool _loading = false;
  List<HistoryModal> _listNhapKho = [];
  List<HistoryModal> _listXuatKho = [];

  int selectedValue = 1;
  bool _firstLoad = false;

  @override
  void initState() {
    super.initState();
    _ab = Provider.of<AppBloc>(context, listen: false);
    _hb = Provider.of<HistoryBloc>(context, listen: false);
    AppService().checkInternet().then((hasInternet) {
      if (!hasInternet!) {
        openSnackBar(context, 'no internet'.tr());
      } else {
        callApi(DateFormat('MM-dd-yyyy').format(DateTime.now()), true);
        callApi(DateFormat('MM-dd-yyyy').format(DateTime.now()), false);
      }
    });
  }

  void callApi(String ngay, bool isNhapKho) {
    setState(() {
      _loading = true;
    });
    _hb.getData(ngay, isNhapKho).then((_) {
      setState(() {
        _loading = false;
        if (isNhapKho) {
          _listNhapKho = _hb.listNhapKho;
        } else {
          _listXuatKho = _hb.listXuatKho;
        }
        if (_firstLoad == false) {
          _firstLoad = true;
        }
      });
    });
  }

  onChangeSelect(value) {
    setState(() {
      selectedValue = value;
      bool isNhapKho = true;
      if (_firstLoad) {
        if (value == 1) {
          isNhapKho = true;
        } else {
          isNhapKho = false;
        }
        callApi(
          DateFormat('MM-dd-yyyy').format(DateTime.now()),
          isNhapKho,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_ab.tenNhomChucNang == null) {
    //   return const Center(
    //       child: Text(
    //     "Bạn chưa cấu hình để sử dụng.",
    //     style: TextStyle(fontSize: 20),
    //   ));
    // }
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            color: Theme.of(context).colorScheme.onPrimary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: 1,
                      groupValue: selectedValue,
                      onChanged: onChangeSelect,
                    ),
                    const Text('Nhập kho'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: 2,
                      groupValue: selectedValue,
                      onChanged: onChangeSelect,
                    ),
                    const Text('Xuất kho'),
                  ],
                ),
              ],
            ),
          ),
          selectedValue == 1
              ? HistoryNhapKhoPage(
                  list: _listNhapKho,
                  callApi: callApi,
                  loading: _loading,
                  firstLoad: _firstLoad,
                )
              : HistoryXuatKhoPage(
                  list: _listXuatKho,
                  callApi: callApi,
                  loading: _loading,
                  firstLoad: _firstLoad,
                ),
        ],
      ),
    );
  }
}
