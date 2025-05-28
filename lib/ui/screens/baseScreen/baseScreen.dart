import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grebo/core/constants/app_assets.dart';
import 'package:grebo/core/service/googleAdd/addServices.dart';
import 'package:grebo/core/service/repo/userRepo.dart';
import 'package:grebo/core/viewmodel/controller/selectservicecontoller.dart';
import 'package:grebo/main.dart';
import 'package:grebo/ui/screens/baseScreen/controller/baseController.dart';
import 'package:grebo/ui/screens/baseScreen/filter_screen.dart';
import 'package:grebo/ui/screens/homeTab/controller/homeController.dart';
import 'package:grebo/ui/screens/homeTab/controller/postDetailController.dart';
import 'package:grebo/ui/screens/homeTab/provider/likeerror.dart';
import 'package:grebo/ui/screens/messagesTab/controller/allChatController.dart';
import 'package:grebo/ui/screens/notifications/controller/allNotificationController.dart';
import 'package:grebo/ui/shared/bottomabar.dart';
import 'package:grebo/ui/shared/doubleTaptoback.dart';
import 'package:grebo/ui/shared/location.dart';
import 'package:grebo/ui/shared/utils_notification.dart';
import '../../global.dart';
import '../homeTab/home.dart';
import '../homeTab/provider/createpost.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final BaseController baseController = Get.find<BaseController>();
  final HomeController homeController = Get.put(HomeController());
  final AllChatController allChatController = Get.put(AllChatController());
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    Get.lazyPut(() => PostDetailController(), fenix: true);
    NotificationUtils().handleAppLunchLocalNotification();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await NotificationUtils().handleNotificationData(message.data);
    });
    // listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // received the message while the app was foreground
      // here the notification is not shown automatically.
      await NotificationUtils().handleNewNotification(message, false);
    });
    FirebaseMessaging.instance.getInitialMessage().then((value) async {
      if (value != null) {
        await NotificationUtils().handleNotificationData(value.data);
      }
    });

    GoogleAddService.showInterstitialAd();
    // if (userController.user.userType ==
    //     getServiceTypeCode(ServicesType.userType)) {
    Get.put(GetCurrentLocation()).determinePosition().then((value) {
      baseController.getAddressFromLatLong(
        LatLongCoordinate(latitude: value.latitude, longitude: value.longitude),
      );
    }).catchError((e) {
      if (userController.user.location.coordinates[0] != 0.0 &&
          userController.user.location.coordinates[1] != 0.0) {
        baseController.getAddressFromLatLong(
          LatLongCoordinate(
            latitude: userController.user.location.coordinates[1],
            longitude: userController.user.location.coordinates[0],
          ),
        );
      }
    });
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseApp(
      child: Scaffold(
        appBar: buildAppBar(),
        body: GetBuilder(
          builder: (BaseController controller) {
            return IndexedStack(
              children: userController.isGuest
                  ? tabNavigationForGuest
                  : tabNavigation,
              //  index: controller.currentTab,
              index: controller.currentTab,
            );
          },
        ),
        bottomNavigationBar: BuildBottomBar(),
        floatingActionButton: userController.user.userType ==
                getServiceTypeCode(ServicesType.providerType)
            ? floatingAction()
            : SizedBox(),
      ),
    );
  }

  floatingAction() {
    return GetBuilder(
      builder: (BaseController controller) => controller.currentTab == 0
          ? GestureDetector(
              onTap: () {
                if (userController.user.verifiedByAdmin)
                  Get.to(() => CreatePost());
                else
                  Get.to(() => LikeError());
              },
              child: buildWidget(AppImages.create, 50, 50),
            )
          : SizedBox(),
    );
  }

  AppBar buildAppBar() {
    List<String> appTitle = [
      'feeds'.tr,
      'messages'.tr,
      'notifications'.tr,
      'profile'.tr
    ];

    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: GetBuilder(
        builder: (BaseController controller) => Text(
          appTitle[controller.currentTab],
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        GetBuilder(
          builder: (BaseController controller) => controller.currentTab == 0
              ? GestureDetector(
                  onTap: () {
                    Get.to(() => FilterScreen());
                  },
                  child: SvgPicture.asset(AppImages.filter),
                )
              : SizedBox(),
        ),
        SizedBox(width: 21),
      ],
    );
  }
}
