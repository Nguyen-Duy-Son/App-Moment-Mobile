import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/custom/widgets/search_data_not_found.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../models/user_model.dart';
import 'my_friend_infomation.dart';

class ListFriendSuggestions extends StatefulWidget {
  const ListFriendSuggestions(
      {super.key,
      required this.users,
      required this.setExpanded,
      required this.isExpanded,
      required this.keySearch});

  final VoidCallback setExpanded;
  final bool isExpanded;
  final List<User> users;
  final String keySearch;

  @override
  State<ListFriendSuggestions> createState() => _ListFriendSuggestionsState();
}

class _ListFriendSuggestionsState extends State<ListFriendSuggestions> {
  @override
  Widget build(BuildContext context) {
    List<User> lists = widget.users
        .where((user) => user.fullName
            .toLowerCase()
            .contains(widget.keySearch.toLowerCase()))
        .toList();
    return lists.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.isExpanded
                      ? lists.length
                      : (lists.length > 3 ? 3 : lists.length),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyFriendInfomationScreen(
                                  user: widget.users[index],
                                  option: 0,
                                ),
                              ),
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              lists[index].avatar!,
                              height: 36.w,
                              width: 36.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lists[index].fullName,
                                style: AppTextStyles.of(context).light20.copyWith(
                                      color: AppColors.of(context).neutralColor12,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SvgPicture.asset(
                                Assets.icons.up2,
                                width: 28.w,
                                height: 28.h,
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
                ),
              ],
            ),
          )
        : const SearchDataNotFound();
  }
}
