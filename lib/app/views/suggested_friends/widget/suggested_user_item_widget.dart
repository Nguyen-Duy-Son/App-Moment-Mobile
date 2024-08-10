import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../l10n/l10n.dart';
import '../../../models/user_model.dart';

class SuggestedUserItemWidget extends StatefulWidget {
  const SuggestedUserItemWidget(
      {super.key,
      required this.index,
      required this.listLength,
      required this.user});
  final int index;
  final User user;
  final int listLength;

  @override
  State<SuggestedUserItemWidget> createState() =>
      _SuggestedUserItemWidgetState();
}

class _SuggestedUserItemWidgetState extends State<SuggestedUserItemWidget> {
  bool isSelectAdd = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.w),
                child: CachedNetworkImage(
                  imageUrl: widget.user.avatar ?? "",
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.fullName ?? "",
                    style: AppTextStyles.of(context).light20.copyWith(
                        color: AppColors.of(context).neutralColor12,
                        height: 0.8.h),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.user.email ?? "",
                    style: AppTextStyles.of(context).light14.copyWith(
                          color: AppColors.of(context).neutralColor11,
                          height: 1.h,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                ],
              ),
            ),
            ScaleOnTapWidget(
              child: isSelectAdd
                  ? SvgPicture.asset(Assets.icons.zoomOut)
                  : SvgPicture.asset(Assets.icons.zoomIn),
              onTap: (isSelect) {
                sendRequest();
              },
            ),
          ],
        ),
        if (widget.index < widget.listLength - 1) ...[
          SizedBox(
            height: 4.h,
          ),
          Divider(
            color: Colors.grey,
            height: ScreenUtil().setHeight(1.0),
          ),
          SizedBox(
            height: 4.h,
          ),
        ]
      ],
    );
  }

  Future<void> sendRequest() async {
    if (!isSelectAdd) {
      setState(() {
        isSelectAdd = true;
      });
      context.read<UserProvider>().sentFriendRequest(widget.user.id);
    }
  }
}
