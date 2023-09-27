import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/config/config.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

Widget loadingButton(
    context, controller, action, title, valueColor, textColor) {
  return RoundedLoadingButton(
    animateOnTap: true,
    controller: controller,
    onPressed: () => action(),
    width: MediaQuery.of(context).size.width * 1.0,
    color: Config().buttonColor,
    valueColor: valueColor,
    borderRadius: 10,
    elevation: 3,
    child: Wrap(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ).tr()
      ],
    ),
  );
}
