import 'package:flutter/material.dart';

showDiaLogItem({
  required BuildContext context,
  required Function actions,
  required Function cancelActions,
  required String title,
  required String content,
  Function? callBack,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('Không'),
            onPressed: () {
              Navigator.of(context).pop(true);
              cancelActions();
            },
          ),
          TextButton(
            child: Text('Có'),
            onPressed: () {
              Navigator.of(context).pop(true);
              actions();
            },
          ),
        ],
      );
    },
  ).then((value) {
    if (value) {
      // callback
      callBack!();
    } else {
      Navigator.pop(context);
    }
  });
}
