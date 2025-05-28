import 'package:get/get.dart';
import 'package:grebo/core/service/repo/userRepo.dart';
import 'package:grebo/core/utils/appFunctions.dart';
import 'package:grebo/main.dart';

class ReportController extends GetxController {
  Future reportUser(String id) async {
    final response = await UserRepo.reportUser(
        id: id, userType: userController.user.userType);
    if (response != null) {
      flutterToast(response["message"]);
      Get.back();
    }
  }
}
