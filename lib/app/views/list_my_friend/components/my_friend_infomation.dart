import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/views/list_my_friend/components/chat_message_view.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../datasource/network_services/user_service.dart';
import '../../../l10n/l10n.dart';
import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';
import 'friend_request.dart';

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
    final String remaining = phone.substring(4); // Start from the 5th character
    final tmp =
        remaining.replaceRange(0, remaining.length, 'X' * remaining.length);
    // Add space after every 3 characters for the remaining part
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
          actions: [
            PopupMenuButton(
              offset: const Offset(
                -16,
                64,
              ),
              shape: const TooltipShape(),
              constraints: BoxConstraints.expand(width: 0.8.sw, height: 0.4.sh),
              padding: EdgeInsets.only(
                top: 15.w,
                right: 15.w,
              ),
              onOpened: () {
                setState(() {
                  checkOpacity = true;
                });
              },
              onCanceled: () {
                setState(() {
                  checkOpacity = false;
                });
              },
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.of(context).neutralColor7,
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: SvgPicture.asset(
                        Assets.icons.bell,
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 1.w,
                    top: -3.w,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorConstants.accentRed,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      width: 20.w,
                      height: 20.w,
                      child: Text(
                        '${Provider.of<UserProvider>(context, listen: false).friendRequests.length ?? 0}',
                        style: AppTextStyles.of(context).light16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              itemBuilder: (_) =>
                  !Provider.of<UserProvider>(context, listen: false)
                          .isLoandingFriendRequests
                      ? _buildFriendRequestMenu(
                          Provider.of<UserProvider>(context, listen: false)
                              .friendRequests)
                      : [
                          const PopupMenuItem(
                              child: Center(child: CircularProgressIndicator()))
                        ],
            ),
          ],
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

  Widget _button(
      String title, Color colorBackGround, Color color, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 32.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: colorBackGround,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: AppColors.of(context).primaryColor9,
            width: 2,
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.of(context).light20.copyWith(
                color: color,
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
                child: _button(
                  S.of(context).delete,
                  AppColors.of(context).neutralColor2,
                  AppColors.of(context).primaryColor9,
                  () {},
                ),
              ),
              SizedBox(
                width: 52.w,
              ),
              Expanded(
                child: _button(
                  S.of(context).addFriend,
                  AppColors.of(context).primaryColor9,
                  AppColors.of(context).neutralColor2,
                  () {},
                ),
              ),
            ]
          : (option == 1
              ? [
                  !isDelete
                      ? Expanded(
                          child: _button(
                            S.of(context).deleteFriend,
                            AppColors.of(context).neutralColor2,
                            AppColors.of(context).primaryColor9,
                            () => showDialogDeleteFriend(widget.user.fullName),
                          ),
                        )
                      : Expanded(
                          child: _button(
                            S.of(context).delete,
                            AppColors.of(context).neutralColor2,
                            AppColors.of(context).primaryColor9,
                            () {},
                          ),
                        ),
                  SizedBox(
                    width: 52.w,
                  ),
                  !isDelete
                      ? Expanded(
                          child: _button(
                            S.of(context).sendMessage,
                            AppColors.of(context).primaryColor10,
                            AppColors.of(context).neutralColor2,
                            () => navigateToChatScreen(),
                          ),
                        )
                      : Expanded(
                          child: _button(
                            S.of(context).addFriend,
                            AppColors.of(context).primaryColor10,
                            AppColors.of(context).neutralColor2,
                            () {},
                          ),
                        ),
                ]
              : [
                  !isConfirmFriendRequest
                      ? (!isDelinceFriendRequest
                          ? Expanded(
                              child: _button(
                                S.of(context).delete,
                                AppColors.of(context).neutralColor2,
                                AppColors.of(context).primaryColor9,
                                () =>confirmFriendRequest(0),
                              ),
                            )
                          : Expanded(
                              child: _button(
                                S.of(context).delete,
                                AppColors.of(context).neutralColor2,
                                AppColors.of(context).primaryColor9,
                                (){},
                              ),
                            ))
                      : Expanded(
                          child: _button(
                            S.of(context).deleteFriend,
                            AppColors.of(context).neutralColor2,
                            AppColors.of(context).primaryColor9,
                            () => showDialogDeleteFriend(widget.user.fullName),
                          ),
                        ),
                  SizedBox(
                    width: 52.w,
                  ),
                  !isConfirmFriendRequest
                      ? (!isDelinceFriendRequest
                          ? Expanded(
                              child: _button(
                              S.of(context).accept,
                              AppColors.of(context).primaryColor10,
                              AppColors.of(context).neutralColor2,
                              () => confirmFriendRequest(1),
                            ))
                          : Expanded(
                              child: _button(
                              S.of(context).addFriend,
                              AppColors.of(context).primaryColor10,
                              AppColors.of(context).neutralColor2,
                              () {},
                            )))
                      : Expanded(
                          child: _button(
                            S.of(context).sendMessage,
                            AppColors.of(context).primaryColor10,
                            AppColors.of(context).neutralColor2,
                            () => navigateToChatScreen(),
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

  void confirmFriendRequest(int option) async {
    int statusCode =
        await UserService.confirmFriendRequestOfUserBy(widget.user.id, option);
    if (statusCode == 200) {
      if (option == 1) {
        isConfirmFriendRequest = true;
      } else {
        isDelinceFriendRequest = true;
      }
      setState(() {
        context.read<UserProvider>().getFriendRequestOfUser();
        context.read<UserProvider>().getFriendOfUser();
      });
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
                  child: _button(
                    S.of(context).yes,
                    AppColors.of(context).primaryColor4,
                    AppColors.of(context).neutralColor11,
                    () async {
                      deleteFriend(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                  child: _button(
                    S.of(context).no,
                    AppColors.of(context).primaryColor7,
                    AppColors.of(context).neutralColor12,
                    () {
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
          user: widget.user,
        ),
      ),
    );
  }
}

class Information extends StatelessWidget {
  const Information({super.key, required this.iconUrl, required this.title});

  final String iconUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconUrl,
            width: 36.w,
            height: 36.h,
          ),
          SizedBox(
            width: 24.w, // Add spacing between icon and text
          ),
          SizedBox(
            width: 180.w,
            child: Text(
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              title,
              style: AppTextStyles.of(context).light20,
            ),
          ),
        ],
      ),
    );
  }
}

class TooltipShape extends ShapeBorder {
  const TooltipShape();

  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Path path = Path();

    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);

    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0);
    path.lineTo(rrect.width - 30, 0);
    path.lineTo(rrect.width - 20, -10);
    path.lineTo(rrect.width - 10, 0);
    path.quadraticBezierTo(rrect.width, 0, rrect.width, 10);
    path.lineTo(rrect.width, rrect.height - 10);
    path.quadraticBezierTo(
        rrect.width, rrect.height, rrect.width - 10, rrect.height);
    path.lineTo(10, rrect.height);
    path.quadraticBezierTo(0, rrect.height, 0, rrect.height - 10);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: _borderRadius * t,
      );
}
