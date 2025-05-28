import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grebo/core/constants/appSetting.dart';
import 'package:grebo/core/constants/app_assets.dart';
import 'package:grebo/core/extension/customButtonextension.dart';
import 'package:grebo/core/service/apiRoutes.dart';
import 'package:grebo/core/service/repo/userRepo.dart';
import 'package:grebo/core/utils/config.dart';
import 'package:grebo/core/viewmodel/controller/imagepickercontoller.dart';
import 'package:grebo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebo/ui/screens/profile/controller/ProfileChangeController.dart';
import 'package:grebo/ui/shared/appbar.dart';
import 'package:grebo/ui/shared/custombutton.dart';
import 'package:grebo/ui/shared/customtextfield.dart';
import 'package:grebo/ui/shared/placeScreen.dart';

import '../../../main.dart';
import '../../global.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileChangeController profileChangeController =
      Get.put(ProfileChangeController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    appImagePicker.imagePickerController.resetImage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'edit_profile'.tr),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder(
                  builder: (ImagePickerController controller) {
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          disposeKeyboard();
                          appImagePicker.openBottomSheet();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: FadeInImage(
                            placeholder: AssetImage(AppImages.placeHolder),
                            image: controller.image == null
                                ? NetworkImage(
                                    "${imageUrl + userController.user.picture}")
                                : FileImage(controller.image as File)
                                    as ImageProvider,
                            height: 94,
                            width: 94,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                AppImages.placeHolder,
                                height: 122,
                                width: 122,
                                fit: BoxFit.cover,
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                getHeightSizedBox(h: 10),
                Center(
                  child: Text(
                    'change_image'.tr,
                    style: TextStyle(fontSize: getProportionateScreenWidth(14)),
                  ),
                ),
                getHeightSizedBox(h: 30),
                Text(
                  'name'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(16)),
                ),
                CustomTextField(
                    controller: profileChangeController.name,
                    validator: (val) =>
                        val!.trim().isEmpty ? "please_enter_name".tr : null,
                    textCapitalization: TextCapitalization.sentences,
                    hintText: 'John smith'),
                getHeightSizedBox(h: 18),
                Text(
                  'email'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(16)),
                ),
                CustomTextField(
                  controller: profileChangeController.email,
                  validator: (val) =>
                      val!.trim().isEmpty ? "please_enter_email".tr : null,
                  hintText: 'johnsmith@gmail.com',
                  enabled: userController.user.email == "" ? true : false,
                ),
                getHeightSizedBox(h: 18),
                userController.user.userType ==
                        getServiceTypeCode(ServicesType.userType)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'location'.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: getProportionateScreenWidth(16)),
                          ),
                          Get.height < 800
                              ? getHeightSizedBox(h: 10)
                              : SizedBox(),
                          locationFiled(),
                        ],
                      )
                    : SizedBox(),
                getHeightSizedBox(h: 280),
                SafeArea(
                  child: CustomButton(
                      type: CustomButtonType.colourButton,
                      text: 'save'.tr,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          profileChangeController.updateUser();
                        }
                      }),
                ),
                getHeightSizedBox(h: 15)
              ],
            ),
          ),
        ),
      ),
    );
  }

  locationFiled() {
    return GestureDetector(
      onTap: () {
        GoogleSearchPlace.buildGooglePlaceSearch().then((value) async {
          profileChangeController.lat = value.late;
          profileChangeController.long = value.long;
          profileChangeController.location.text = value.address;
        });
      },
      child: TextFormField(
        style: TextStyle(
          fontSize: getProportionateScreenWidth(14),
        ),
        controller: profileChangeController.location,
        validator: (val) => val!.isEmpty ? "enter_location".tr : null,
        enabled: false,
        textInputAction: TextInputAction.next,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            errorStyle: TextStyle(
              color: Theme.of(Get.context as BuildContext)
                  .colorScheme
                  .error, // or any other color
            ),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              width: 1,
              color: Theme.of(Get.context as BuildContext).colorScheme.error,
            )),
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              width: 0.5,
            )),
            hintStyle: TextStyle(
                fontSize: getProportionateScreenWidth(14),
                color: Color(0xff8F92A3)),
            hintText: 'Villaz Johns Street 11, California..',
            suffixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 0, 12),
              child: SvgPicture.asset(
                AppImages.gps,
              ),
            )),
      ),
    );
  }
}
