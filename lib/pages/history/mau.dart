import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/blocs/mau_bloc.dart';
import 'package:ghethanhpham_thaco/models/history.dart';
import 'package:ghethanhpham_thaco/models/mamau.dart';
import 'package:ghethanhpham_thaco/widgets/divider.dart';
import 'package:ghethanhpham_thaco/widgets/loading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MauPage extends StatefulWidget {
  List<MauModel> list;
  Function callApi;
  bool loading;
  bool firstLoad;

  MauPage({
    super.key,
    required this.list,
    required this.callApi,
    required this.loading,
    required this.firstLoad,
  });

  @override
  State<MauPage> createState() => _MauPageState();
}

class _MauPageState extends State<MauPage> {
  @override
  void initState() {
    final MauBloc mb = Provider.of<MauBloc>(context, listen: false);
    mb.getData();
    super.initState();
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
                                  Text(item.maMau),
                                  Text(item.tenMaMau),
                                  Text(item.tenLoaiXe),
                                ],
                              ),
                              // trailing: Column(
                              //   children: [
                              //     Text(item.thoiGianNhap),
                              //     Text(
                              //       item.thoiGianHuy,
                              //       style: const TextStyle(
                              //         color: Colors.redAccent,
                              //       ),
                              //     ),
                              //   ],
                              // ),
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
