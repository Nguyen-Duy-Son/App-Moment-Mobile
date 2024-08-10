import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/custom/widgets/button_select_option.dart';
import 'package:hit_moments/app/views/conversation/components/chat_message_view.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/extensions/theme_extensions.dart';
import '../../../../custom/widgets/tool_tip_shape.dart';
import '../../../../datasource/network_services/user_service.dart';
import '../../../../l10n/l10n.dart';
import '../../../../models/user_model.dart';
import '../../../../providers/user_provider.dart';
import '../friend_request.dart';
import 'information.dart';

class MyFriendInfomationScreen extends StatefulWidget {
  final User user;
  final int option;

  MyFriendInfomationScreen({
    super.key,
    required this.user,
    required this.option,
  });

  @override
  State<MyFriendInfomationScreen> createState() =>
      _MyFriendInfomationScreenState();
}

class _MyFriendInfomationScreenState extends State<MyFriendInfomationScreen> {
  bool checkOpacity = false;

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  String formatPhone(String phone) {
    final String firstPart = phone.substring(0, 4);
    final String remaining = phone.substring(4);
    final tmp =
        remaining.replaceRange(0, remaining.length, 'X' * remaining.length);
    final String formattedRemaining =
        tmp.replaceAllMapped(RegExp(r".{3}"), (match) {
      return '${match.group(0)} ';
    });

    final String formatted = '$firstPart $formattedRemaining';

    return formatted.trim(); // Use trim to remove the trailing space
  }

  bool isDelete = false;
  bool isConfirmFriendRequest = false;
  bool isDelinceFriendRequest = false;
  bool isSentRequest = false;
  bool isCancelSentRequest = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(top: 15.w),
            child: BackButton(
              color: AppColors.of(context).neutralColor9,
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 15.w),
            child: Text(
              overflow: TextOverflow.ellipsis,
              S.of(context).friend,
              style: AppTextStyles.of(context).bold32,
            ),
          ),
          centerTitle: true,
          // actions: [
          //   PopupMenuButton(
          //     offset: const Offset(
          //       -16,
          //       64,
          //     ),
          //     shape: const TooltipShape(),
          //     constraints: BoxConstraints.expand(width: 0.8.sw, height: 0.4.sh),
          //     padding: EdgeInsets.only(
          //       top: 15.w,
          //       right: 15.w,
          //     ),
          //     onOpened: () {
          //       setState(() {
          //         checkOpacity = true;
          //       });
          //     },
          //     onCanceled: () {
          //       setState(() {
          //         checkOpacity = false;
          //       });
          //     },
          //     icon: Stack(
          //       clipBehavior: Clip.none,
          //       children: [
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(50),
          //           child: Container(
          //             decoration: BoxDecoration(
          //               color: AppColors.of(context).neutralColor7,
          //             ),
          //             padding: EdgeInsets.all(8.w),
          //             child: SvgPicture.asset(
          //               Assets.icons.bell,
          //               width: 20.w,
          //               height: 20.w,
          //             ),
          //           ),
          //         ),
          //         Positioned(
          //           right: 1.w,
          //           top: -3.w,
          //           child: Container(
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(
          //               color: ColorConstants.accentRed,
          //               borderRadius: BorderRadius.circular(50),
          //             ),
          //             width: 20.w,
          //             height: 20.w,
          //             child: Text(
          //               '${Provider.of<UserProvider>(context, listen: false).friendRequests.length ?? 0}',
          //               style: AppTextStyles.of(context).light16,
          //               overflow: TextOverflow.ellipsis,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //     itemBuilder: (_) =>
          //         !Provider.of<UserProvider>(context, listen: false)
          //                 .isLoandingFriendRequests
          //             ? _buildFriendRequestMenu(
          //                 Provider.of<UserProvider>(context, listen: false)
          //                     .friendRequests)
          //             : [
          //                 const PopupMenuItem(
          //                     child: Center(child: CircularProgressIndicator()))
          //               ],
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Stack(children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 60.h),
                  padding: EdgeInsets.only(top: 80.h),
                  height: 500.h,
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primaryColor2,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.of(context).neutralColor8,
                        offset: const Offset(0, -2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.user.fullName,
                          style: AppTextStyles.of(context).bold20,
                        ),
                        SizedBox(height: 20.h),
                        widget.user.phoneNumber != null
                            ? Information(
                                iconUrl: Assets.icons.call,
                                title: formatPhone(widget.user.phoneNumber!),
                              )
                            : SizedBox(),
                        widget.user.dob != null
                            ? Information(
                                iconUrl: Assets.icons.calendar,
                                title: formatDate(widget.user.dob!),
                              )
                            : SizedBox(),
                        Information(
                          iconUrl: Assets.icons.mail,
                          title: widget.user.email!,
                        ),
                        SizedBox(height: 100.h),
                        _buildSelectButtonByOption(widget.option),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    widget.user.avatar!,
                    height: 120.w,
                    width: 120.h,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectButtonByOption(int option) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: option == 0
          ? [
              Expanded(
                child: ButtonSelectOption(
                  title: S.of(context).delete,
                  colorBackGround: AppColors.of(context).neutralColor2,
                  color: AppColors.of(context).primaryColor9,
                  onTap: () {},
                ),
              ),
              SizedBox(
                width: 52.w,
              ),
              isSentRequest == false
                  ? (isCancelSentRequest == false
                      ? Expanded(
                          child: ButtonSelectOption(
                          title: S.of(context).addFriend,
                          colorBackGround: AppColors.of(context).primaryColor9,
                          color: AppColors.of(context).neutralColor2,
                          onTap: () => sentRequestFriend(),
                        ))
                      : Expanded(
                          child: ButtonSelectOption(
                            title: S.of(context).cancelAddFriend,
                            colorBackGround:
                                AppColors.of(context).primaryColor9,
                            color: AppColors.of(context).neutralColor2,
                            onTap: () => cancelSentRequestByUserId(),
                          ),
                        ))
                  : Expanded(
                      child: ButtonSelectOption(
                        title: S.of(context).cancelAddFriend,
                        colorBackGround: AppColors.of(context).primaryColor9,
                        color: AppColors.of(context).neutralColor2,
                        onTap: () => cancelSentRequestByUserId(),
                      ),
                    ),
            ]
          : (option == 1
              ? [
                  !isDelete
                      ? Expanded(
                          child: ButtonSelectOption(
                            title: S.of(context).deleteFriend,
                            colorBackGround:
                                AppColors.of(context).neutralColor2,
                            color: AppColors.of(context).primaryColor9,
                            onTap: () =>
                                showDialogDeleteFriend(widget.user.fullName),
                          ),
                        )
                      : Expanded(
                          child: ButtonSelectOption(
                            title: S.of(context).delete,
                            colorBackGround:
                                AppColors.of(context).neutralColor2,
                            color: AppColors.of(context).primaryColor9,
                            onTap: () {},
                          ),
                        ),
                  SizedBox(
                    width: 52.w,
                  ),
                  !isDelete
                      ? Expanded(
                          child: ButtonSelectOption(
                            title: S.of(context).sendMessage,
                            colorBackGround:
                                AppColors.of(context).primaryColor10,
                            color: AppColors.of(context).neutralColor2,
                            onTap: () => navigateToChatScreen(),
                          ),
                        )
                      : (isSentRequest == false
                          ? Expanded(
                              child: ButtonSelectOption(
                                title: S.of(context).addFriend,
                                colorBackGround:
                                    AppColors.of(context).primaryColor9,
                                color: AppColors.of(context).neutralColor2,
                                onTap: () => sentRequestFriend(),
                              ),
                            )
                          : Expanded(
                              child: ButtonSelectOption(
                                title: S.of(context).cancelAddFriend,
                                colorBackGround:
                                    AppColors.of(context).primaryColor9,
                                color: AppColors.of(context).neutralColor2,
                                onTap: () => cancelSentRequestByUserId(),
                              ),
                            )),
                ]
              : [
                  isConfirmFriendRequest == false
                      ? (isDelinceFriendRequest == false
                          ? Expanded(
                              child: ButtonSelectOption(
                                title: S.of(context).delete,
                                colorBackGround:
                                    AppColors.of(context).neutralColor2,
                                color: AppColors.of(context).primaryColor9,
                                onTap: () => confirmFriendRequest(0),
                              ),
                            )
                          : Expanded(
                              child: ButtonSelectOption(
                                title: S.of(context).delete,
                                colorBackGround:
                                    AppColors.of(context).neutralColor2,
                                color: AppColors.of(context).primaryColor9,
                                onTap: () {},
                              ),
                            ))
                      : Expanded(
                          child: ButtonSelectOption(
                            title: S.of(context).deleteFriend,
                            colorBackGround:
                                AppColors.of(context).neutralColor2,
                            color: AppColors.of(context).primaryColor9,
                            onTap: () =>
                                showDialogDeleteFriend(widget.user.fullName),
                          ),
                        ),
                  SizedBox(
                    width: 52.w,
                  ),
                  isConfirmFriendRequest == false
                      ? (isDelinceFriendRequest == false
                          ? Expanded(
                              child: ButtonSelectOption(
                                title: S.of(context).accept,
                                colorBackGround:
                                    AppColors.of(context).primaryColor10,
                                color: AppColors.of(context).neutralColor2,
                                onTap: () => confirmFriendRequest(1),
                              ),
                            )
                          : (isSentRequest == false
                              ? Expanded(
                                  child: ButtonSelectOption(
                                    title: S.of(context).addFriend,
                                    colorBackGround:
                                        AppColors.of(context).primaryColor9,
                                    color: AppColors.of(context).neutralColor2,
                                    onTap: () => sentRequestFriend(),
                                  ),
                                )
                              : Expanded(
                                  child: ButtonSelectOption(
                                    title: S.of(context).cancelAddFriend,
                                    colorBackGround:
                                        AppColors.of(context).primaryColor9,
                                    color: AppColors.of(context).neutralColor2,
                                    onTap: () => cancelSentRequestByUserId,
                                  ),
                                )))
                      : Expanded(
                          child: ButtonSelectOption(
                            title: S.of(context).sendMessage,
                            colorBackGround:
                                AppColors.of(context).primaryColor10,
                            color: AppColors.of(context).neutralColor2,
                            onTap: () => navigateToChatScreen(),
                          ),
                        ),
                ]),
    );
  }

  List<PopupMenuItem> _buildFriendRequestMenu(List<User> users) {
    List<PopupMenuItem> items = users
        .map(
          (e) => PopupMenuItem(
            child: FriendRequest(
              user: e,
            ),
          ),
        )
        .toList();
    items.insert(
      0,
      PopupMenuItem(
        enabled: false,
        child: Text(
          overflow: TextOverflow.ellipsis,
          S.of(context).friendRequest,
          style: AppTextStyles.of(context).bold20,
        ), // Disable the item so it can't be selected
      ),
    );
    return items;
  }

  void deleteFriend(BuildContext ct) async {
    int statusCode = await UserService.deleteFriendOfUserById(widget.user.id);
    if (statusCode == 200) {
      setState(() {
        isDelete = true;
        context.read<UserProvider>().getFriendOfUser();
      });
      print("Huỷ kết bạn thành công");
      Navigator.pop(ct);
    } else {
      print("Huỷ kết bạn thất bại");
    }
  }

  void cancelSentRequestByUserId() async {
    print("Huỷ yêu cầu kết bạn");
    int statusCode = await UserService.cancelRequestByUserId(widget.user.id);
    if (statusCode == 200) {
      setState(() {
        isSentRequest = false;
      });
      print("Huỷ yêu cầu kết bạn thành công");
    } else {
      print("Huỷ yêu cầu kết bạn thất bại");
    }
  }

  void sentRequestFriend() async {
    int statusCode = await UserService.sentRequestById(widget.user.id);
    if (statusCode == 200) {
      setState(() {
        isSentRequest = true;
      });
      print("Gửi yêu cầu kết bạn thành công");
    } else {
      print("Gửi yêu cầu kết bạn thất bại");
    }
  }

  void confirmFriendRequest(int option) async {
    int statusCode =
        await UserService.confirmFriendRequestOfUserBy(widget.user.id, option);
    if (statusCode == 200) {
      if (option == 1) {
        setState(() {
          isConfirmFriendRequest = true;
        });
      } else {
        setState(() {
          isDelinceFriendRequest = true;
        });
      }
      context.read<UserProvider>().getFriendRequestOfUser();
      context.read<UserProvider>().getFriendOfUser();
    } else {
      print("Xác nhận yêu cầu lỗi");
    }
  }

  void showDialogDeleteFriend(String fullName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Bạn có chắc chắn muốn huỷ kết bạn với ${fullName} không?',
            textAlign: TextAlign.center,
            style: AppTextStyles.of(context)
                .bold20
                .copyWith(color: AppColors.of(context).neutralColor11),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ButtonSelectOption(
                    title: S.of(context).yes,
                    colorBackGround: AppColors.of(context).primaryColor4,
                    color: AppColors.of(context).neutralColor11,
                    onTap: () => deleteFriend(context),
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                  child: ButtonSelectOption(
                    title: S.of(context).no,
                    colorBackGround: AppColors.of(context).primaryColor7,
                    color: AppColors.of(context).neutralColor12,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void navigateToChatScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatMessageView(
          receiver: widget.user,
          conversationId: '',
        ),
      ),
    );
  }
}
