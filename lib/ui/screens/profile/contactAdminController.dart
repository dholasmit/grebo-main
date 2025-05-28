import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:grebo/core/constants/appcolor.dart';
import 'package:grebo/core/service/repo/contactRepo.dart';
import 'package:grebo/ui/shared/alertdialogue.dart';

class ContactAdminController extends GetxController {
  String helpText = "";
  Future conatctAdmin() async {
    var response = await ContactRepo.adminContact(helpText: helpText);
    if (response != null) {
      showCustomDialog(
          context: Get.context as BuildContext,
          height: 150,
          content: 'dialog_msg'.tr,
          contentSize: 15,
          onTap: () {
            Get.back();
            Get.back();
          },
          color: AppColor.kDefaultColor,
          okText: 'ok'.tr);
    }
  }
}
