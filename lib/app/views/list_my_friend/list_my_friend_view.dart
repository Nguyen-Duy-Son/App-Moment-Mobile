import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:hit_moments/app/views/list_my_friend/list_my_friend_widget.dart';
import 'package:provider/provider.dart';

import '../../core/constants/assets.dart';
import '../../core/constants/text_style_constants.dart';
import '../../l10n/l10n.dart';
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
    //
    context.read<UserProvider>().getUser();
    context.read<UserProvider>().getFriendOfUser();
    context.read<UserProvider>().getMyFriendsUsers();
    context.read<UserProvider>().getFriendRequests();
    context.read<UserProvider>().getFriendProposals();
    //
    super.initState();
  }

  bool checkOpacity = false;

  @override
  Widget build(BuildContext context) {
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
                style: AppTextStyles.of(context).bold32,
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
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      checkOpacity = true;
                    });
                  });
                },
                onCanceled: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      checkOpacity = false;
                    });
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
                          color: ColorConstants.accentRed,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 20.w,
                        height: 20.w,
                        child: Text(
                          '${Provider.of<UserProvider>(context, listen: false).friendRequests.length ?? 0}',
                          style: AppTextStyles.of(context).light16,
                        ),
                      ),
                    ),
                  ],
                ),
                itemBuilder: (_) =>
                    _buildFriendRequestMenu(Provider.of<UserProvider>(context, listen: false).friendRequests),
              ),
            ],
          ),
          body: Opacity(
              opacity: checkOpacity ? 0.3 : 1,
              child: ListMyFriendWidget(friendProposals: Provider.of<UserProvider>(context, listen: false).friendProposals,
                  friendsUsers: Provider.of<UserProvider>(context, listen: false).friendsUsers))),
    );
  }

  List<PopupMenuItem> _buildFriendRequestMenu(
      List<User> users) {
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
            style: AppTextStyles.of(context).bold20,
          ),
        ),
        enabled: false, // Disable the item so it can't be selected
      ),
    );
    return items;
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
