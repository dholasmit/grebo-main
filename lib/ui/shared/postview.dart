import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grebo/core/constants/appSetting.dart';
import 'package:grebo/core/constants/app_assets.dart';
import 'package:grebo/core/constants/appcolor.dart';
import 'package:grebo/core/extension/dateTimeFormatExtension.dart';
import 'package:grebo/core/service/apiRoutes.dart';
import 'package:grebo/core/service/repo/postRepo.dart';
import 'package:grebo/core/service/repo/userRepo.dart';
import 'package:grebo/core/utils/config.dart';
import 'package:grebo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebo/main.dart';
import 'package:grebo/ui/global.dart';
import 'package:grebo/ui/screens/homeTab/businessprofile.dart';
import 'package:grebo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebo/ui/screens/homeTab/controller/postDetailController.dart';
import 'package:grebo/ui/screens/homeTab/home.dart';
import 'package:grebo/ui/screens/homeTab/model/postModel.dart';
import 'package:grebo/ui/screens/homeTab/postdetails.dart';
import 'package:grebo/ui/screens/homeTab/provider/editPost.dart';
import 'package:grebo/ui/screens/homeTab/videoScreen.dart';
import 'package:grebo/ui/screens/homeTab/viewcomments.dart';
import 'package:grebo/ui/screens/homeTab/widget/guestLoginScreen.dart';
import 'package:grebo/ui/shared/alertdialogue.dart';
import 'package:grebo/ui/shared/controller/delete_controller.dart';
import 'package:grebo/ui/shared/userController.dart';
import 'package:readmore/readmore.dart';

import '../screens/messagesTab/post_screen.dart';

class PostView extends StatelessWidget {
  final PostData postData;
  final HomeController homeScreenController = Get.find<HomeController>();
  final bool isPostDetail;
  final bool isProfileClickable;
  bool isFromProfile = false;

  PostView({
    Key? key,
    required this.postData,
    this.isPostDetail = false,
    this.isProfileClickable = true,
    this.isFromProfile = false,
  }) : super(key: key);
  final DeleteController deleteController = Get.find<DeleteController>();
  final PostDetailController postDetailController =
      Get.find<PostDetailController>();
  bool option = true;
  final ServiceController serviceController = Get.find<ServiceController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getHeightSizedBox(h: 8),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (isPostDetail == false) {
                        homeScreenController.currentPostRef = postData.id;
                        Get.to(
                          () => PostDetails(postRef: postData.id),
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getHeightSizedBox(h: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              profileImageView(),
                              getHeightSizedBox(w: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: getProportionateScreenWidth(275),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (isProfileClickable == false) {
                                              return;
                                            }
                                            if (userController.isGuest) {
                                              Get.to(() => GuestLoginScreen());
                                              return;
                                            }

                                            debugPrint(postData.userRef);
                                            Get.to(() => BusinessProfile(
                                                  businessRef: postData.userRef,
                                                ));
                                          },
                                          child: Text(
                                            postData
                                                .postUserDetail.businessName,
                                            style: TextStyle(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                16,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        getHeightSizedBox(w: 5),
                                        buildWidget(
                                          postData.postUserDetail
                                                  .verifiedByAdmin
                                              ? AppImages.verified
                                              : AppImages.warning,
                                          20,
                                          20,
                                        ),
                                        Spacer(),
                                        (userController.user.userType ==
                                                    getServiceTypeCode(
                                                        ServicesType
                                                            .providerType)) &&
                                                isFromProfile
                                            ? GestureDetector(
                                                onTap: () {
                                                  bottomShit(
                                                      context: context,
                                                      EditOnTap: () {
                                                        Get.back();
                                                        Get.to(() => EditPost(
                                                            postData:
                                                                postData));
                                                        PostScreen
                                                            .paginationPostKey
                                                            .currentState!
                                                            .refresh();
                                                      },
                                                      yesOnTap: () {
                                                        deleteController
                                                            .getDelete(
                                                          postRef: postData.id,
                                                        );
                                                        Get.back();

                                                        PostScreen
                                                            .paginationPostKey
                                                            .currentState!
                                                            .refresh();
                                                      });
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10,
                                                      ),
                                                      child: SvgPicture.asset(
                                                          AppImages.optionIc)),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    DateTimeFormatExtension
                                        .displayTimeFromTimestampForPost(
                                      postData.createdAt.toLocal(),
                                    ),
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(14),
                                      color: AppColor.kDefaultFontColor
                                          .withOpacity(0.57),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        postData.video == "" && postData.image == ""
                            ? SizedBox()
                            : GestureDetector(
                                onTap: () {
                                  if (isPostDetail) {
                                    if (postData.image == "") {
                                      debugPrint("ok");
                                      Get.to(
                                        () => VideoScreen(
                                            path:
                                                "${videoUrl + postData.video}"),
                                      );
                                    }
                                  } else {
                                    homeScreenController.currentPostRef =
                                        postData.id;
                                    Get.to(
                                      () => PostDetails(
                                        postRef: postData.id,
                                      ),
                                    );
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ClipRRect(
                                        child: FadeInImage(
                                          placeholder:
                                              AssetImage(AppImages.placeHolder),
                                          image: postData.image == ""
                                              ? NetworkImage(
                                                  "${imageUrl + postData.thumbnail}")
                                              : NetworkImage(
                                                  "${imageUrl + postData.image}"),
                                          height: Get.width - 94,
                                          width: Get.width,
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              AppImages.placeHolder,
                                              height: Get.width - 94,
                                              width: Get.width,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    postData.image == ""
                                        ? SvgPicture.asset(AppImages.videoPlay)
                                        : SizedBox()
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              postData.text == ""
                                  ? getHeightSizedBox(h: 5)
                                  : getHeightSizedBox(h: 10),
                              postData.text == ""
                                  ? SizedBox()
                                  : ReadMoreText(
                                      postData.text,
                                      trimLines: 3,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                        fontFamily: 'Nexa',
                                        color: AppColor.kDefaultFontColor
                                            .withOpacity(0.89),
                                      ),
                                      lessStyle: TextStyle(
                                        color: AppColor.kDefaultFontColor,
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'see_all'.tr,
                                      trimExpandedText: 'see_less'.tr,
                                      moreStyle: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(14),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Divider(),
                        getHeightSizedBox(h: 3),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  disposeKeyboard();
                                  if (userController.isGuest) {
                                    Get.to(() => GuestLoginScreen());
                                    return;
                                  }

                                  if (isPostDetail) {
                                    final postDetailController =
                                        Get.find<PostDetailController>();

                                    postDetailController.postDataModel.isLike =
                                        !postDetailController
                                            .postDataModel.isLike;

                                    if (postDetailController
                                        .postDataModel.isLike) {
                                      postDetailController.postDataModel.like +=
                                          1;
                                    } else {
                                      postDetailController.postDataModel.like -=
                                          1;
                                    }
                                    homeScreenController.likeUpdate(postData);

                                    postDetailController.update();

                                    PostRepo.likeUpdate(
                                        postDetailController.postDataModel.id,
                                        postDetailController
                                            .postDataModel.isLike);
                                  } else {
                                    homeScreenController.likeUpdate(postData);
                                    PostRepo.likeUpdate(
                                        postData.id, postData.isLike);
                                  }
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      buildWidget(
                                        postData.isLike
                                            ? AppImages.like
                                            : AppImages.unlike,
                                        15,
                                        17,
                                      ),
                                      getHeightSizedBox(w: 5),
                                      Text(
                                        postData.like.toString(),
                                        style: TextStyle(
                                          fontSize: getProportionateScreenWidth(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              getHeightSizedBox(w: 20),
                              GestureDetector(
                                onTap: () {
                                  disposeKeyboard();
                                  if (userController.isGuest) {
                                    Get.to(() => GuestLoginScreen());
                                    return;
                                  }
                                  homeScreenController.currentPostRef =
                                      postData.id;
                                  Get.to(() => ViewComments(
                                        postData: postData,
                                      ));
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      buildWidget(AppImages.comment, 15, 16),
                                      getHeightSizedBox(w: 5),
                                      Text(
                                        postData.comment.toString(),
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(
                                                    12)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        getHeightSizedBox(h: 7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  GestureDetector profileImageView() {
    return GestureDetector(
      onTap: () {
        if (isProfileClickable == false) {
          return;
        }
        if (userController.isGuest) {
          Get.to(
            () => GuestLoginScreen(),
          );
          return;
        }

        Get.to(
          () => BusinessProfile(
            businessRef: postData.userRef,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: FadeInImage(
          placeholder: AssetImage(AppImages.placeHolder),
          // image: userController.user.userType ==
          //         getServiceTypeCode(ServicesType.providerType)
          //     ? NetworkImage("${imageUrl + userController.user.picture}")
          //image: NetworkImage("${imageUrl + postData.postUserDetail.picture}"),
          image: networkImageShow2(imageUrl + postData.postUserDetail.picture),
          height: 44,
          width: 44,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              AppImages.placeHolder,
              height: 44,
              width: 44,
              fit: BoxFit.cover,
            );
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Widget buildCircleProfile(
    {required String image, required double height, required double width}) {
  return Container(
    height: getProportionateScreenWidth(height),
    width: getProportionateScreenWidth(width),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
  );
}

Widget uploadProfile(
    {required String image, required double height, required double width}) {
  return Container(
    height: getProportionateScreenWidth(height),
    width: getProportionateScreenWidth(width),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        image:
            DecorationImage(image: FileImage(File(image)), fit: BoxFit.cover)),
  );
}

bottomShit({
  required BuildContext context,
  required dynamic Function()? yesOnTap,
  required void Function() EditOnTap,
}) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                bottomShitContainer(
                  onTap: EditOnTap,
                  Color: AppColor.showModelBottomShitColor,
                  txt: "Edit Post",
                  fontSize: 16,
                ),
                bottomShitContainer(
                  onTap: () {
                    Get.back();
                    showCustomBox(context: context, yesonTap: yesOnTap);
                  },
                  Color: AppColor.showModelBottomShitColor,
                  txt: "Delete Post",
                  fontSize: 16,
                ),
                bottomShitContainer(
                  onTap: () {
                    Get.back();
                  },
                  Color: Colors.white,
                  txt: "Cancel",
                  fontSize: 20,
                ),
              ],
            ),
          ),
        );
      });
}

bottomShitContainer({
  required Color Color,
  required String txt,
  required void Function() onTap,
  required double fontSize,
}) {
  return Column(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Color,
          ),
          child: Center(
            child: Text(
              txt,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: kAppFont,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 10),
    ],
  );
}

showCustomBox(
    {required BuildContext context, required dynamic Function()? yesonTap}) {
  return showCustomDialog1(
    context: context,
    content: "Are you sure you want to delete this post?",
    title: "Delete Post",
    contentSize: 16,
    color: AppColor.bottomShitColor,
    okText: "No",
    noText: "Yes",
    noonTap: () {
      Get.back();
    },
    yesonTap: yesonTap,
  );
}
