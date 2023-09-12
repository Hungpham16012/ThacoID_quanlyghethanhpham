import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghethanhpham_thaco/models/chuc_nang.dart';

// ignore: must_be_immutable
class SettingNhaMay extends StatefulWidget {
  List<ChucNangItemModel> chucNangs;
  String? optionItem;
  Function onChangeSelect;

  SettingNhaMay({
    super.key,
    required this.chucNangs,
    required this.optionItem,
    required this.onChangeSelect,
  });

  @override
  State<SettingNhaMay> createState() => _SettingNhaMayState();
}

class _SettingNhaMayState extends State<SettingNhaMay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.chucNangs.map((cn) {
        return ListTile(
          leading: const Icon(
            FontAwesomeIcons.boxArchive,
          ),
          title: Text(cn.tenChucNang),
          trailing: Radio(
            value: cn.chuyenId,
            onChanged: (value) => widget.onChangeSelect(value, cn.tenChucNang),
            groupValue: widget.optionItem,
            activeColor: Theme.of(context).primaryColor,
          ),
        );
      }).toList(),
    );
  }
}
