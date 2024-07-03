import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hit_moments/app/custom/widgets/search_data_not_found.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/color_constants.dart';
import '../../../models/user_model.dart';

class ListFriendSuggestions extends StatefulWidget {
  const ListFriendSuggestions({
    super.key,
    required this.users,
    required this.setExpanded,
    required this.isExpanded,
    required this.keySearch
  });

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
    double width = MediaQuery.of(context).size.width;
    List<User> lists = widget.users.where((user) =>
        user.fullName
            .toLowerCase()
            .contains(widget.keySearch.toLowerCase()))
        .toList();
    return lists.isNotEmpty? SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.isExpanded ? lists.length : (lists.length > 3 ? 3 : lists.length),
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
                        Assets.icons.up2,
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
      ),
    ):const SearchDataNotFound();
  }
}