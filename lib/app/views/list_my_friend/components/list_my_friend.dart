import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/color_constants.dart';
import '../../../custom/widgets/search_data_not_found.dart';
import '../../../models/user_model.dart';

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
    double width = MediaQuery.of(context).size.width;
    List<User> lists = widget.users
        .where((user) => user.fullName
            .toLowerCase()
            .contains(widget.keySearch.toLowerCase()))
        .toList();

    return lists.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: widget.isExpanded
                ? lists.length
                : (lists.length > 3 ? 3 : lists.length),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Image.network(
                        lists[index].avatar!,
                        height: 40.w,
                        width: 40.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lists[index].fullName,
                          style: TextStyle(
                            fontSize: 20.w,
                            color: ColorConstants.neutralLight120,
                          ),
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
                  Container(
                    height: 1.0,
                    margin: EdgeInsets.only(
                      top: 6.h,
                      bottom: 6.h,
                    ),
                    padding: EdgeInsets.only(
                      left: 12.w,
                      right: 12.w,
                    ),
                    width: width * 0.75,
                    color: ColorConstants.neutralLight80,
                  ),
                ],
              );
            },
          )
        : const SearchDataNotFound();
  }
}
