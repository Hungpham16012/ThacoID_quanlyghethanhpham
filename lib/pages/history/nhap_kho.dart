import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/models/history.dart';
import 'package:ghethanhpham_thaco/widgets/divider.dart';
import 'package:ghethanhpham_thaco/widgets/loading.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class HistoryNhapKhoPage extends StatefulWidget {
  List<HistoryModal> list;
  Function callApi;
  bool loading;
  bool firstLoad;

  HistoryNhapKhoPage({
    super.key,
    required this.list,
    required this.callApi,
    required this.loading,
    required this.firstLoad,
  });

  @override
  State<HistoryNhapKhoPage> createState() => _HistoryXacNhanTienDoPageState();
}

class _HistoryXacNhanTienDoPageState extends State<HistoryNhapKhoPage> {
  DateTime _selectedDate = DateTime.now();
  String _formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);
      });
      var ngay = DateFormat('MM-dd-yyyy').format(picked);
      // call API
      widget.callApi(ngay, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var id = 0;
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.onPrimary,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formattedDate,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 15),
              InkWell(
                onTap: () => _selectDate(context),
                child: Icon(
                  Icons.date_range,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        widget.loading
            ? LoadingWidget(height: 100)
            : widget.list.isEmpty
                ? const Center(
                    child: Text(
                      "Không có dữ liệu",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : Container(
                    color: Theme.of(context).colorScheme.onPrimary,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: widget.list.map((item) {
                        id++;
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(5),
                              horizontalTitleGap: 1.0,
                              tileColor: Colors.amber,
                              leading: Text("$id"),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.maChiTiet),
                                  Text(item.tenChiTiet),
                                  Text(item.maCode),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Text(item.thoiGianNhap),
                                  Text(
                                    item.thoiGianHuy,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const DividerWidget(),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
      ],
    );
  }
}
