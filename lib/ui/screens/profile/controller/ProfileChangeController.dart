import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebo/core/service/repo/editProfileRepo.dart';
import 'package:grebo/core/service/repo/userRepo.dart';
import 'package:grebo/core/utils/appFunctions.dart';
import 'package:grebo/core/utils/sharedpreference.dart';
import 'package:grebo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebo/ui/global.dart';
import 'package:grebo/ui/screens/baseScreen/controller/baseController.dart';
import 'package:grebo/ui/screens/login/model/currentUserModel.dart';

import '../../../../main.dart';

class ProfileChangeController extends GetxController {
  final TextEditingController name = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController location = TextEditingController();
  double lat = -1;
  double long = -1;

  Future updateUser() async {
    EditProfileRepo.updateUser(
            map: userController.user.userType ==
                    getServiceTypeCode(ServicesType.userType)
                ? {
                    "name": name.text.trim(),
                    "latitude": lat,
                    "longitude": long,
                    "address": location.text.trim(),
                    "email": email.text.trim()
                  }
                : {"name": name.text.trim(), "email": email.text.trim()},
            image: appImagePicker.imagePickerController.image)
        .then((v) {
      if (v != null) {
        Get.find<BaseController>().baseAddress = location.text.trim();

        appImagePicker.imagePickerController.resetImage();
        updateUserDetail(UserModel.fromJson(v['data']));
        print("***********************************");
        print(userController.user.toJson());
        flutterToast(v["message"]);
        Get.back();
      }
    });
  }

  @override
  void onInit() {
    name.text = userController.user.name;
    email.text = userController.user.email;
    lat = userController.user.location.coordinates[0];
    long = userController.user.location.coordinates[1];
    location.text = userController.user.location.address;

    super.onInit();
  }
}
