import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:ghethanhpham_thaco/blocs/theme_bloc.dart';

class SettingGeneral extends StatefulWidget {
  const SettingGeneral({super.key});

  @override
  State<SettingGeneral> createState() => _SettingGeneralState();
}

class _SettingGeneralState extends State<SettingGeneral> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'general settings',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.7,
              wordSpacing: 1,
            ),
          ).tr(),
          const SizedBox(height: 15),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              radius: 18,
              child: Icon(
                Icons.wb_sunny,
                size: 18,
                color: Colors.white,
              ),
            ),
            title: Text(
              'dark mode',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ).tr(),
            trailing: Switch(
              activeColor: Theme.of(context).primaryColor,
              value: context.watch<ThemeBloc>().darkTheme!,
              onChanged: (_) {
                context.read<ThemeBloc>().toggleTheme();
              },
            ),
          ),
          //   const SizedBox(height: 15),
          //    _buildLanguageDropdown(context),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    return InkWell(
      onTap: () {
        _showLanguagePicker(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.language, // Thay bằng biểu tượng ngôn ngữ của bạn
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(
              selectedValue == null
                  ? 'Chọn ngôn ngữ'
                  : selectedValue == 'en'
                      ? 'English'
                      : selectedValue == 'vi'
                          ? 'Tiếng Việt'
                          : '', // Thêm các ngôn ngữ khác ở đây
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_drop_down, // Biểu tượng mũi tên xuống
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('English'),
                onTap: () {
                  setState(() {
                    selectedValue = 'en';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Tiếng Việt'),
                onTap: () {
                  setState(() {
                    selectedValue = 'vi';
                  });
                  Navigator.of(context).pop();
                },
              ),
              // Thêm các ngôn ngữ khác ở đây
            ],
          ),
        );
      },
    );
  }
}
