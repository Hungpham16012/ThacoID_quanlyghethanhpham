import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ghethanhpham_thaco/models/chucnang_model.dart';
import 'package:ghethanhpham_thaco/pages/home/main.dart';

class SettingNhaMay extends StatefulWidget {
  final List<ChucNangItemModel> listFeatures;
  final String? optionItem;
  final Function onChangeSelect;

  const SettingNhaMay({
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
        return InkWell(
          onTap: () {
            // Navigate to MainPage with the feature name
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    MainPage(featureName: feature.tenChucNang),
              ),
            );
          },
          child: ListTile(
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
          ),
        );
      }).toList(),
    );
  }
}
