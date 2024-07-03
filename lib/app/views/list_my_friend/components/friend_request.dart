import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/text_style_constants.dart';
import '../../../models/user_model.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({
    super.key,
    required this.user,
    r
  });
  final User user;
  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Image.network(
              widget.user.avatar!,
              height: 0.1 * width,
              width: 0.1 * width,
              fit: BoxFit.cover,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.user.fullName,
                style: TextStyle(
                  fontSize: 0.05 * width,
                  color: ColorConstants.neutralLight120,
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      Assets.icons.delete,
                      width: 0.06 * width,
                      height: 0.06 * width,
                    ),
                  ),
                  SizedBox(width: 0.02 * width),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      Assets.icons.up2,
                      width: 0.06 * width,
                      height: 0.06 * width,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          margin: EdgeInsets.only(
            top: 0.02 * height,
            bottom: 0.02 * height,
          ),
          padding: EdgeInsets.only(
            left: 0.02 * width,
            right: 0.02 * width,
          ),
          width: width * 0.7,
          color: ColorConstants.neutralLight80,
        ),
      ],
    );
  }

}
