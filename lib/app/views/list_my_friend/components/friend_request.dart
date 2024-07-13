import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_style_constants.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../models/user_model.dart';
import 'my_friend_infomation.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({
    super.key,
    required this.user,
  });
  final User user;
  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyFriendInfomationScreen(
                  user: widget.user,
                  option: 2,
                ),
              ),
            );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              widget.user.avatar!,
              height: 36.w,
              width: 36.w,
              fit: BoxFit.cover,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.user.fullName,
                style: AppTextStyles.of(context).light20.copyWith(
                  color: AppColors.of(context).neutralColor12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      Assets.icons.delete,
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      Assets.icons.up2,
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Container(
            height: 1.0,
            margin: EdgeInsets.only(
              top: 10.w,
              bottom: 10.w,
            ),
            padding: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
            ),
            color: AppColors.of(context).neutralColor11,
          ),
        ),
      ],
    );
  }

}
