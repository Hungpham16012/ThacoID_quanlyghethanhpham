import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../blocs/user_bloc.dart';
import '../pages/login.dart';
import 'next_screen.dart';

void signOut(context) async {
  // final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
  // final AppBloc ab = Provider.of<AppBloc>(context, listen: false);
  // await ub.userSignout().then((_) {
  //   ab.clearData().then((_) {
  //     nextScreenCloseOthers(
  //       context,
  //       const LoginPage(),
  //     );
  //   });
  // });
}

void openLogoutDialog(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('logout description').tr(),
          title: const Text('logout title').tr(),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('cancel').tr(),
            ),
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  signOut(context);
                },
                child: const Text('logout').tr()),
          ],
        );
      });
}
