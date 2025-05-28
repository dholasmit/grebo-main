import 'package:flutter/material.dart';
import 'package:grebo/core/constants/appSetting.dart';

import 'appcolor.dart';

class AppTheme {
  static final ThemeData defTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryIconTheme: IconThemeData(color: Colors.black),
    fontFamily: kAppFont,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: Colors.transparent,
      centerTitle: true,
      actionsIconTheme: IconThemeData(size: 16, color: Colors.black),
    ),
    textTheme: TextTheme(
        bodyMedium: TextStyle(
      color: AppColor.kDefaultFontColor,
    )),
  );
}
