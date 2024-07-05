import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../custom/widgets/search_data_not_found.dart';
import '../../../models/user_model.dart';
import 'my_friend_infomation.dart';

class ListMyFriend extends StatefulWidget {
  const ListMyFriend({
    super.key,
    required this.users,
    required this.setExpanded,
    required this.isExpanded,
    required this.keySearch,
    // required this.setDownUp,
    // required this.isDownUp,
  });

  final VoidCallback setExpanded;
  // final VoidCallback setDownUp;

  final bool isExpanded;
  // final bool isDownUp;
  final List<User> users;
  final String keySearch;

  @override
  State<ListMyFriend> createState() => _ListMyFriendState();
}

class _ListMyFriendState extends State<ListMyFriend> {
  @override
  Widget build(BuildContext context) {
    // List<User> lists = widget.users
    //     .where((user) => user.fullName
    //         .toLowerCase()
    //         .contains(widget.keySearch.toLowerCase()))
    //     .toList();

    return widget.users.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: widget.isExpanded
                ? widget.users.length
                : (widget.users.length > 3 ? 3 : widget.users.length),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       // builder: (context) =>
                    //       //     MyFriendInfomationScreen(
                    //       //   user: lists[index],
                    //       // ),
                    //     ),
                    //   );
                    // },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        widget.users[index].avatar!,
                        height: 36.w,
                        width: 36.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.users[index].fullName,
                          style: AppTextStyles.of(context).light20.copyWith(
                            color: AppColors.of(context).neutralColor12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(
                            Assets.icons.rightArrow,
                            width: 20.w,
                            height: 20.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      height: 1.0,
                      margin: EdgeInsets.only(
                        top: 6.h,
                        bottom: 6.h,
                      ),
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 12.w,
                      ),
                      color: AppColors.of(context).neutralColor11,
                    ),
                  ),
                ],
              );
            },
          )
        : const SearchDataNotFound();
  }
}
