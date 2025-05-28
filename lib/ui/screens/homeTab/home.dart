import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grebo/core/constants/appSetting.dart';
import 'package:grebo/core/constants/app_assets.dart';
import 'package:grebo/core/constants/appcolor.dart';
import 'package:grebo/core/utils/config.dart';
import 'package:grebo/ui/screens/baseScreen/controller/baseController.dart';
import 'package:grebo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebo/ui/screens/homeTab/model/postModel.dart';
import 'package:grebo/ui/screens/homeTab/viewAllCategories.dart';
import 'package:grebo/ui/shared/custombutton.dart';
import 'package:grebo/ui/shared/placeScreen.dart';
import 'package:grebo/ui/shared/postview.dart';
import 'package:grebo/ui/shared/userController.dart';
import 'package:pagination_view/pagination_view.dart';
import '../../../main.dart';
import 'controller/postDetailController.dart';

class Home extends StatefulWidget {
  static GlobalKey<PaginationViewState> paginationViewKey =
      GlobalKey<PaginationViewState>();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // userController.user.userType ==
        //         getServiceTypeCode(ServicesType.userType)
        //     ?
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  buildWidget(AppImages.location, 18, 13),
                  SizedBox(
                    width: getProportionateScreenWidth(9),
                  ),
                  GetBuilder(
                    builder: (BaseController controller) => SizedBox(
                        width: getProportionateScreenWidth(250),
                        height: 18,
                        child: Text(
                          controller.address,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(14),
                              color:
                                  AppColor.kDefaultFontColor.withOpacity(0.75)),
                        )),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await GoogleSearchPlace.buildGooglePlaceSearch()
                          .then((value) async {
                        if (!(value.long == 0 &&
                            value.late == 0 &&
                            value.address == "")) {
                          Get.find<BaseController>().changeAddress(
                              value.late, value.long, value.address);
                        }
                      });
                    },
                    child: Text(
                      'change'.tr,
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            getHeightSizedBox(h: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Row(
                children: [
                  Text(
                    'business_categories'.tr,
                    style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ViewAll());
                    },
                    child: Text(
                      'view_all'.tr,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                      ),
                    ),
                  )
                ],
              ),
            ),
            getHeightSizedBox(h: 12),
            GetBuilder(
              builder: (HomeController controller) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(left: kDefaultPadding),
                    child: GetBuilder(
                      builder: (UserController c) => Row(
                        children: List.generate(
                            userController.globalCategory.length, (index) {
                          var catRef = userController.globalCategory[index];

                          return BusinessCategories(
                            text: catRef.name,
                            textStyle: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              color: controller.selectedCategory
                                      .contains(catRef.id)
                                  ? Colors.white
                                  : AppColor.kDefaultFontColor,
                            ),
                            onTap: () {
                              controller.updateCategory(catRef.id);
                            },
                            height: 38,
                            backgroundColor:
                                controller.selectedCategory.contains(catRef.id)
                                    ? AppColor.kDefaultColor
                                    : Colors.white,
                            border: Border.all(
                              color: AppColor.categoriesColor,
                              width: 1,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                );
              },
            ),
            getHeightSizedBox(h: 10),
            Divider(
              height: 0,
            ),
          ],
        ),
        //   : SizedBox(),
        Expanded(
          child: GetBuilder(
            builder: (HomeController controller) => PaginationView(
              key: Home.paginationViewKey,
              pullToRefresh: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder:
                  (BuildContext context, PostData postData, int index) =>
                      PostView(
                postData: postData,
              ),
              pageFetch: controller.fetchUserPost,
              // userController.user.userType ==
              //         getServiceTypeCode(ServicesType.userType)
              //     ? controller.fetchUserPost
              //     : controller.fetchProviderPost,
              onError: (error) {
                return Center(child: Text(error));
              },
              onEmpty: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Home.paginationViewKey.currentState!.refresh();
                      },
                      icon: Icon(Icons.restart_alt),
                    ),
                    Text("no_posts_yet".tr),
                  ],
                ),
              ),
              initialLoader: GetPlatform.isAndroid
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Center(
                      child: CupertinoActivityIndicator(),
                    ),
            ),
          ),
        )
      ],
    );
  }
}

Widget buildWidget(String image, double height, double width) {
  return Container(
    height: getProportionateScreenWidth(height),
    width: getProportionateScreenWidth(width),
    child: SvgPicture.asset(
      image,
      fit: BoxFit.fill,
    ),
  );
}
