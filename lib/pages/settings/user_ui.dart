import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/user_bloc.dart';
import 'package:ghethanhpham_thaco/ultis/sign_out.dart';
import 'package:ghethanhpham_thaco/widgets/divider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: must_be_immutable
class UserUI extends StatelessWidget {
  String? onlineVersion;
  Function callUpdateAction;
  Map<String, dynamic>? values;
  UserUI(
      {super.key,
      required this.onlineVersion,
      required this.callUpdateAction,
      required this.values});

  @override
  Widget build(BuildContext context) {
    final UserBloc ub = context.watch<UserBloc>();
    final AppBloc ab = context.watch<AppBloc>();
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const CircleAvatar(
            backgroundColor: Colors.greenAccent,
            radius: 18,
            child: Icon(
              FontAwesomeIcons.cloud,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            ab.apiUrl,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const CircleAvatar(
            backgroundColor: Colors.black,
            radius: 18,
            child: Icon(
              FontAwesomeIcons.wrench,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Phiên bản: ${ab.appVersion!}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Text(
              onlineVersion ?? "",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          onTap: () => callUpdateAction(values),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 18,
            child: Icon(
              FontAwesomeIcons.user,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            ub.name!.toString(),
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
              FontAwesomeIcons.mailchimp,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            ub.email!,
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
              FontAwesomeIcons.rightFromBracket,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            'logout',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ).tr(),
          trailing: const Icon(FontAwesomeIcons.chevronRight),
          onTap: () => openLogoutDialog(context),
        ),
      ],
    );
  }
}
