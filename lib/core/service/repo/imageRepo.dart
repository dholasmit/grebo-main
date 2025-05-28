import 'dart:io';

import 'package:grebo/core/service/apiRoutes.dart';
import 'package:grebo/core/utils/appFunctions.dart';
import 'package:grebo/main.dart';

import '../apiHandler.dart';

class ImageRepo {
  static Future uploadImage({required List<File> fileImage}) async {
    try {
      bool connection = await checkConnection();

      if (connection) {
        var response = await API.multiPartAPIHandler(
          fileImage: fileImage,
          url: APIRoutes.imageAdd,
        );
        return response;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future deleteImage({required String imageId}) async {
    try {
      bool connection = await checkConnection();

      if (connection) {
        var response = await API.apiHandler(
            url: APIRoutes.imageDelete,
            body: {"image": imageId},
            header: {'Authorization': userController.userToken});
        return response;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
