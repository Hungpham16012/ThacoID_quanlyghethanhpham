import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ghethanhpham_thaco/blocs/user_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/ultis/sign_out.dart';
import 'package:ghethanhpham_thaco/widgets/divider.dart';

// ignore: must_be_immutable
class UserUI extends StatelessWidget {
  String? onlineVersion;
  Function callUpdateAction;
  Map<String, dynamic>? values;
  UserUI({
    super.key,
    required this.onlineVersion,
    required this.callUpdateAction,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = context.watch<UserBloc>();
    final AppBloc appBloc = context.watch<AppBloc>();
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const CircleAvatar(
            backgroundColor: Colors.greenAccent,
            radius: 18,
            child: Icon(
              Feather.cloud,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            appBloc.apiUrl,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const CircleAvatar(
            backgroundColor: Colors.black,
            radius: 18,
            child: Icon(
              Feather.activity,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Phiên bản: ${appBloc.appVersion!}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          // trailing: Container(
          //   padding: const EdgeInsets.all(10),
          //   decoration: const BoxDecoration(
          //     color: Colors.green,
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(10),
          //     ),
          //   ),
          //   child: Text(
          //     onlineVersion ?? "",
          //     style: const TextStyle(color: Colors.white),
          //   ),
          // ),
          onTap: () => callUpdateAction(values),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 18,
            child: Icon(
              Feather.user_check,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            userBloc.name!.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const DividerWidget(),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent[100],
            radius: 18,
            child: const Icon(
              Feather.mail,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            userBloc.email!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const DividerWidget(),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.redAccent[100],
            radius: 18,
            child: const Icon(
              Feather.log_out,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            'logout',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ).tr(),
          trailing: const Icon(Feather.chevron_right),
          onTap: () => openLogoutDialog(context),
        ),
      ],
    );
  }
}
