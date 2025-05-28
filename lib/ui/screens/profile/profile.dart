import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grebo/core/constants/appSetting.dart';
import 'package:grebo/core/constants/app_assets.dart';
import 'package:grebo/core/constants/appcolor.dart';
import 'package:grebo/core/service/apiRoutes.dart';
import 'package:grebo/core/service/repo/userRepo.dart';
import 'package:grebo/core/utils/config.dart';
import 'package:grebo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebo/ui/screens/baseScreen/controller/baseController.dart';
import 'package:grebo/ui/screens/homeTab/businessprofile.dart';
import 'package:grebo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebo/ui/screens/homeTab/home.dart';
import 'package:grebo/ui/screens/homeTab/serviceoffered.dart';
import 'package:grebo/ui/screens/profile/provider/availability.dart';
import 'package:grebo/ui/screens/profile/settings.dart';
import 'package:grebo/ui/shared/userController.dart';

import '../../../main.dart';
import '../messagesTab/post_screen.dart';
import 'editprofile.dart';

class ProfileScreen extends StatelessWidget {
  final HomeController homeScreenController = Get.find<HomeController>();
  final BaseController baseController = Get.find<BaseController>();

  final List<Map<String, dynamic>> list = [
    {
      'title': 'posts'.tr,
      'onTap': () {
        Get.to(() => PostScreen(
              businessRef: userController.user.id,
              isFromProfile: true,
            ));
      },
      "image": AppImages.posts
    },
    {
      'title': 'about_business'.tr,
      'onTap': () {
        Get.to(() => BusinessProfile(
              isShow: true,
              businessRef: userController.user.id,
            ));
      },
      "image": AppImages.aboutBusiness
    },
    {
      'title': 'availability'.tr,
      'onTap': () {
        Get.to(() => Availability());
      },
      "image": AppImages.availability
    },
    {
      'title': 'services_offered'.tr,
      'onTap': () {
        Get.to(() => ServiceOffered(
              isEdit: true,
            ));
      },
      "image": AppImages.serviceOffer
    },
    {
      'title': 'settings'.tr,
      'onTap': () {
        Get.to(() => Settings());
      },
      "image": AppImages.setting
    }
  ];
  bool profilePicker = false;

  @override
  Widget build(BuildContext context) {
    log("PROFILE BUILD ");
    if (userController.user.id != "") {
      userController.fetchUserDetail1();
    }
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Stack(
            children: [
              GetBuilder(
                builder: (UserController controller) => ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: FadeInImage(
                    placeholder: AssetImage(AppImages.placeHolder),
                    image: NetworkImage(
                        "${imageUrl + userController.user.picture}"),
                    height: 122,
                    width: 122,
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
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => EditProfile());
                  },
                  child: buildWidget(AppImages.edit, 38, 38),
                ),
              ),
            ],
          ),
          // GestureDetector(
          //     onTap: () {
          //       homeScreenController.fetchUserDetail1();
          //     },
          //     child: Container(
          //       height: 100,
          //       width: 100,
          //       color: Colors.orangeAccent,
          //     )),
          getHeightSizedBox(h: 20),
          GetBuilder(
            builder: (UserController controller) {
              log("UPDATE USER");
              return Container(
                height: 64,
                color: AppColor.profileFollowContainer,
                child: Row(
                  children: [
                    Spacer(),
                    profileFollower(
                      num: "${userController.user.followers}",
                      txt: "followers".tr,
                    ),
                    getHeightSizedBox(w: 20),
                    profileFollower(
                      num: "${userController.user.following}",
                      // num: "${userController.userModel.following}",
                      txt: "following".tr,
                    ),
                    Spacer(),
                  ],
                ),
              );
            },
          ),
          getHeightSizedBox(h: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xffEDEDED),
                      offset: Offset(0, 1),
                      blurRadius: 6)
                ]),
            child: GetBuilder(
              builder: (UserController controller) => Column(
                children: [
                  buildSettingTile(
                    image: AppImages.user,
                    height: 21,
                    width: 17,
                    title: 'user_name'.tr,
                    subtitle: userController.user.name,
                  ),
                  userController.user.userType ==
                          getServiceTypeCode(ServicesType.userType)
                      ? GetBuilder(
                          builder: (BaseController controller) =>
                              buildSettingTile(
                            image: AppImages.location,
                            height: 20,
                            width: 14,
                            title: 'location'.tr,
                            subtitle: userController.user.location.address,
                          ),
                        )
                      : SizedBox(),
                  buildSettingTile(
                    image: AppImages.email,
                    height: 20,
                    width: 20,
                    title: 'email_address'.tr,
                    subtitle: userController.user.email,
                  ),
                ],
              ),
            ),
          ),
          getHeightSizedBox(h: 10),
          userController.user.userType == 1
              ? buildTile(
                  'settings'.tr,
                  () {
                    Get.to(() => Settings());
                  },
                  AppImages.setting,
                )
              : Column(
                  children: List.generate(
                    list.length,
                    (index) => buildTile(
                      list[index]['title'],
                      list[index]['onTap'],
                      list[index]['image'],
                    ),
                  ),
                ),
          Divider(
            height: 0,
          )
        ],
      ),
    );
  }

  Widget profileFollower({required String num, required String txt}) {
    return Column(
      children: [
        Spacer(),
        Text(
          num,
          style: TextStyle(
            fontFamily: kAppFont,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 5),
        Text(
          txt,
          style: TextStyle(
            fontFamily: kAppFont,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Spacer(),
      ],
    );
  }
}

Widget buildSettingTile(
    {required String image,
    required String title,
    required String subtitle,
    required double height,
    required double width}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 15),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 20,
            height: 20,
            child: Center(
              child: SvgPicture.asset(image),
            )),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(13)),
                ),
                getHeightSizedBox(h: 7),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: Color(0xff6E6E6E).withOpacity(0.85),
                      fontSize: getProportionateScreenWidth(14)),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
