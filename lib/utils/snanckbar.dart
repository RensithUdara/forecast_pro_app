import 'package:flutter/material.dart';
import 'package:forecast_pro_app/constants/constants.dart';

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: appTextStyle(),
      ),
      backgroundColor: Colors.black,
    ),
  );
}
