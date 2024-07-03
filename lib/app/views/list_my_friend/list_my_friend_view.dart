import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/views/list_my_friend/list_my_friend_widget.dart';

import '../../core/constants/assets.dart';
import '../../core/constants/text_style_constants.dart';
import '../../models/friend.model.dart';
import '../../models/user_model.dart';
import 'components/friend_request.dart';

class ListMyFriendView extends StatefulWidget {
  const ListMyFriendView({super.key});

  @override
  State<ListMyFriendView> createState() => _ListMyFriendViewState();
}

class _ListMyFriendViewState extends State<ListMyFriendView> {
  @override
  void initState() {
    super.initState();
  }

  bool checkOpacity = false;
  final List<User> friendsUsers =
      usersF.where((user) => friend.friendsList!.contains(user.id)).toList();
  final List<User> friendRequestUsers =
      usersF.where((user) => friend.friendRequests!.contains(user.id)).toList();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.only(top: 15.w),
              child: const BackButton(
                color: ColorConstants.neutralLight90,
              ),
            ),
            title: Padding(
              // Padding around the title for a similar effect
              padding: EdgeInsets.only(top: 15.w),
              child: Text(
                AppLocalizations.of(context)!.friend,
                style: TextStyle(fontSize: 32.w),
              ),
            ),
            centerTitle: true,
            actions: [
              // Padding(
              //   padding: EdgeInsets.only(top: 15.w, right: 15.w),
              //   child:
              //   Stack(
              //     clipBehavior: Clip.none,
              //     children: [
              //
              //       InkWell(
              //         onTap: () {
              //           // showDialog(
              //           //   context: context,
              //           //   useSafeArea: true,
              //           //   builder: (context) {
              //           //     return ListFriendRequests(users: usersF);
              //           //   },
              //           // );
              //
              //         },
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(200),
              //           child: Container(
              //             decoration: const BoxDecoration(
              //               color: ColorConstants.neutralLight70,
              //             ),
              //             padding: EdgeInsets.all(8.w),
              //             child: SvgPicture.asset(
              //               Assets.icons.bell,
              //               width: 22.w,
              //               height: 22.w,
              //             ),
              //           ),
              //         ),
              //       ),
              //       Positioned(
              //         right: 1.w,
              //         top: -5.w,
              //         child: Container(
              //           alignment: Alignment.center,
              //           decoration: BoxDecoration(
              //             color: Colors.red,
              //             borderRadius: BorderRadius.circular(50),
              //           ),
              //           width: 17.w,
              //           height: 17.w,
              //           child: Text(
              //             '${friend.friendRequests?.length ?? 0}',
              //             style: TextStyle(
              //               color: ColorConstants.neutralLight10,
              //               fontSize: 13.w,
              //             ),
              //             textAlign: TextAlign.center,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              PopupMenuButton(
                offset: const Offset(
                  -16,
                  64,
                ),
                shape: const TooltipShape(),
                constraints:
                    BoxConstraints.expand(width: 0.8.sw, height: 0.4.sh),
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
                        decoration: const BoxDecoration(
                          color: ColorConstants.neutralLight70,
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
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 16.w,
                        height: 16.w,
                        child: Text(
                          '${friend.friendRequests?.length ?? 0}',
                          style: TextStyle(
                            color: ColorConstants.neutralLight10,
                            fontSize: 12.w,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                itemBuilder: (_) =>
                    _buildFriendRequestMenu(friendRequestUsers, width, 0.5.h),
              ),
            ],
          ),
          body: Opacity(
              opacity: checkOpacity ? 0.3 : 1,
              child: ListMyFriendWidget(friend: friend, users: usersF))),
    );
  }

  List<PopupMenuItem> _buildFriendRequestMenu(
      List<User> users, double width, double height) {
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
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.friendRequest,
            style: TextStyleConstant.boldLight22,
          ),
        ),
        enabled: false, // Disable the item so it can't be selected
      ),
    );
    return items;
  }
}

// Bạn bè của người dùng
final Friend friend = Friend(
  userId: '1',
  friendsList: ['2', '3', '6', '7'],
  friendRequests: ['4', '5', '8', '9'],
  friendSuggestions: ['10', '11', '12', '13'],
);
// Thông tin của bạn bè
final List<User> usersF = [
  User(
    id: '2',
    fullName: 'Nguyễn Văn Nam',
    avatar:
        'https://cdn.thoitiet247.edu.vn/wp-content/uploads/2024/04/nhung-hinh-anh-girl-xinh-de-thuong.webp',
  ),
  User(
    id: '3',
    fullName: 'Trần Thị Ngọc',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-27.webp',
  ),
  User(
    id: '4',
    fullName: 'Phạm Văn Tú',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-7.webp',
  ),
  User(
    id: '5',
    fullName: 'Lê Thị Hồng',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-6.webp',
  ),
  User(
    id: '6',
    fullName: 'Nguyễn Văn E',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-30.webp',
  ),
  User(
    id: '7',
    fullName: 'Trần Thị F',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
  ),
  User(
    id: '8',
    fullName: 'Nguyễn Thị F',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
  ),
  User(
    id: '9',
    fullName: 'Trần Nguyễn',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
  ),
  User(
    id: '10',
    fullName: 'Nguyễn Thị H',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
  ),
  User(
    id: '11',
    fullName: 'Trần Thị H',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
  ),
  User(
    id: '12',
    fullName: 'Nguyễn Văn H',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
  ),
  User(
    id: '13',
    fullName: 'Trần Văn H',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
  ),
];

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
