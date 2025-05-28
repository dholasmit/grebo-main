import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grebo/core/constants/appSetting.dart';
import 'package:grebo/core/constants/appcolor.dart';
import 'package:grebo/core/extension/dateTimeFormatExtension.dart';
import 'package:grebo/core/utils/config.dart';
import 'package:grebo/ui/screens/messagesTab/controller/allChatController.dart';
import 'package:grebo/ui/screens/messagesTab/controller/chatScreenController.dart';
import 'package:grebo/ui/screens/messagesTab/model/chatListModel.dart';
import 'package:grebo/ui/screens/messagesTab/model/messageModel.dart';
import 'package:grebo/ui/shared/appbar.dart';
import 'package:grebo/ui/shared/postdetailbottom.dart';

import '../../../main.dart';

class ChatView extends StatefulWidget {
  final String businessRef;
  final String channelRef;
  final String userName;
  final AllChatData? allChatData;

  ChatView(
      {Key? key,
      this.channelRef = "",
      required this.businessRef,
      required this.userName,
      this.allChatData})
      : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatScreenController chatScreenController =
      Get.put(ChatScreenController());
  @override
  void initState() {
    chatScreenController.businessRef = widget.businessRef;
    chatScreenController.channelRef = widget.channelRef;
    chatScreenController.fetchChannel();
    scrollController.addListener(scrollListener);
    super.initState();
  }

  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (chatScreenController.hasNext) {
        chatScreenController.fetchNextMessages();
      }
    }
  }

  @override
  void deactivate() {
    debugPrint("deactive");
    if (chatScreenController.lastMessage != null) {
      AllChatController controller = Get.find<AllChatController>();
      int index = controller.getChatList.indexWhere(
          (element) => element.chatUserDetail.id == widget.businessRef);
      if (index != -1) {
        controller.getChatList[index].lastMessage =
            chatScreenController.lastMessage!;
        controller.update();
      }
    }

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        disposeKeyboard();
      },
      child: Scaffold(
          appBar: appBar(title: widget.userName),
          body: GetBuilder(
            builder: (ChatScreenController controller) {
              return controller.channelRef == "" &&
                      controller.getMessages.isEmpty
                  ? GetPlatform.isAndroid
                      ? Center(
                          child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ))
                      : Center(child: CupertinoActivityIndicator())
                  : Stack(
                      children: [
                        ListView.builder(
                          controller: scrollController,
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.getMessages.length,
                          padding:
                              EdgeInsets.only(bottom: 90, left: 13, right: 13),
                          itemBuilder: (context, index) {
                            return messageBoxView(
                              controller.getMessages[index],
                            );
                          },
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: SafeArea(
                              child: PostDetailsBottomView(
                                comment: chatScreenController.messageText,
                                send: () {
                                  if (chatScreenController.messageText.text
                                      .trim()
                                      .isNotEmpty) {
                                    chatScreenController.sendMessages();
                                  }
                                },
                                hintText: 'textfieldmsg2'.tr,
                              ),
                            ))
                      ],
                    );
            },
          )),
    );
  }

  messageBoxView(MessageData messageData) {
    if (messageData.userId == userController.user.id) {
      // Right (my message)

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColor.kDefaultColor,
                borderRadius: BorderRadius.circular(22)),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(left: 50),
            child: Text(messageData.message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(14),
                )),
          ),
          getHeightSizedBox(h: 7),
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: Text(
              DateTimeFormatExtension.displayMSGTimeFromTimestamp(
                  messageData.createdAt.toLocal()),
              style: TextStyle(
                  color: Color(0xff7C8392),
                  fontSize: getProportionateScreenWidth(11)),
            ),
          ),
          getHeightSizedBox(h: 4),
        ],
      );
    } else {
      // Left (defence message)

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xffF3F3F3),
                borderRadius: BorderRadius.circular(22)),
            margin: EdgeInsets.only(right: 50),
            padding: EdgeInsets.all(15),

            child: Text(messageData.message,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                )),
            // margin: const EdgeInsets.only(left: 10.0),
          ),
          getHeightSizedBox(h: 7),
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: Text(
              DateTimeFormatExtension.displayMSGTimeFromTimestamp(
                  messageData.createdAt.toLocal()),
              style: TextStyle(
                  color: Color(0xff7C8392),
                  fontSize: getProportionateScreenWidth(11)),
            ),
          ),
          getHeightSizedBox(h: 4),
        ],
      );
    }
  }
}
