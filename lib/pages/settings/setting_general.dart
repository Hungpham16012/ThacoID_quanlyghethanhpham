import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ghethanhpham_thaco/blocs/theme_bloc.dart';
import 'package:provider/provider.dart';

class SettingGeneral extends StatefulWidget {
  const SettingGeneral({super.key});

  @override
  State<SettingGeneral> createState() => _SettingGeneralState();
}

class _SettingGeneralState extends State<SettingGeneral> {
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
                  color: Theme.of(context).colorScheme.primary),
            ).tr(),
            trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                value: context.watch<ThemeBloc>().darkTheme!,
                onChanged: (_) {
                  context.read<ThemeBloc>().toggleTheme();
                }),
          ),
        ],
      ),
    );
  }
}
