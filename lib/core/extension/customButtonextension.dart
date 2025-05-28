import 'package:flutter/material.dart';
import 'package:grebo/core/constants/appcolor.dart';
import 'package:grebo/core/utils/config.dart';
import 'package:grebo/ui/shared/custombutton.dart';

enum CustomButtonType {
  colourButton,
  borderButton,
}

extension CustomButtonExtension on CustomButtonType {
  ButtonProps get props {
    switch (this) {
      case CustomButtonType.colourButton:
        return ButtonProps(
          height: 50,
          radius: 50,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: getProportionateScreenWidth(15),
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: AppColor.kDefaultColor,
        );

      case CustomButtonType.borderButton:
        return ButtonProps(
          height: 50,
          radius: 50,
          border: Border.all(color: Color(0xff009345), width: 1),
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: getProportionateScreenWidth(15),
            fontWeight: FontWeight.w700,
          ),
          backgroundColor: Colors.white,
        );
    }
  }
}
