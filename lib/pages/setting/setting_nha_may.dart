import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ghethanhpham_thaco/models/chucnang_model.dart';

// ignore: must_be_immutable
class SettingNhaMay extends StatefulWidget {
  List<ChucNangItemModel> listFeatures;
  String? optionItem;
  Function onChangeSelect;

  SettingNhaMay({
    super.key,
    required this.listFeatures,
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
      children: widget.listFeatures.map((feature) {
        return ListTile(
          leading: const Icon(
            Feather.archive,
          ),
          title: Text(feature.tenChucNang),
          trailing: Radio(
            value: feature.chuyenId,
            onChanged: (value) => widget.onChangeSelect(
              value,
              feature.tenChucNang,
            ),
            groupValue: widget.optionItem,
            activeColor: Theme.of(context).primaryColor,
          ),
        );
      }).toList(),
    );
  }
}
