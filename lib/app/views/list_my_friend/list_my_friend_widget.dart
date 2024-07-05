import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import 'components/list_friend_proposal.dart';
import 'components/list_my_friend.dart';

class ListMyFriendWidget extends StatefulWidget {
  const ListMyFriendWidget(
      {super.key, required this.friendsUsers, required this.friendProposals});

  final List<User> friendsUsers,friendProposals;


  @override
  State<ListMyFriendWidget> createState() => _ListMyFriendWidgetState();
}

class _ListMyFriendWidgetState extends State<ListMyFriendWidget> {
  @override
  void initState() {
    // context.read<UserProvider>().getMyFriendsUsers();
    // context.read<UserProvider>().getFriendRequestsUsers();
    // context.read<UserProvider>().getFriendProposalsUsers();
    super.initState();
  }
  bool checkColorList = false;
  bool isExpandedMyFriend = false;
  bool isExpandedFriendProposals = false;
  bool isDownUpMyFriend = false;
  bool isDownUpFriendProposals = false;


  void toggleColor(String title) {
    setState(() {
      if (title == AppLocalizations.of(context)!.list) {
        checkColorList = false;
      } else if (title == AppLocalizations.of(context)!.proposal) {
        checkColorList = true;
      }
    });
  }

  void setExpandedMyFriend() {
    setState(() {
      isExpandedMyFriend = !isExpandedMyFriend;
    });
  }

  void setExpandedFriendProposals() {
    setState(() {
      isExpandedFriendProposals = !isExpandedFriendProposals;
    });
  }

  void setIsDownUpMyFriend() {
    setState(() {
      isDownUpMyFriend = !isDownUpMyFriend;
    });
  }
  void setIsDownUpFriendProposals() {
    setState(() {
      isDownUpFriendProposals = !isDownUpFriendProposals;
    });
  }

  final TextEditingController _searchController = TextEditingController();
  String? searchValue;

  @override
  Widget build(BuildContext context) {
    // List<User> friendsUsers = widget.users
    //     .where((user) => widget.friend.friendsList!.contains(user.id))
    //     .toList();
    // List<User> friendSuggestions = widget.users
    //     .where((user) =>
    //         widget.friend.friendSuggestions!.contains(user.id) ?? false)
    //     .toList();
    // print(_searchController.text);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20.h,
              bottom: 22.h,
            ),
            decoration: BoxDecoration(
              color: ColorConstants.primaryLight10,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: ColorConstants.neutralLight80,
                width: 1,
              ),
            ),
            child: IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabBarMyFriend(
                    title: AppLocalizations.of(context)!.list,
                    checkColor: !checkColorList,
                    toggleColor: () =>
                        toggleColor(AppLocalizations.of(context)!.list),
                  ),
                  TabBarMyFriend(
                    title: AppLocalizations.of(context)!.proposal,
                    checkColor: checkColorList,
                    toggleColor: () =>
                        toggleColor(AppLocalizations.of(context)!.proposal),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
            ),
            child: TextFormField(
              controller: _searchController,
              initialValue: searchValue,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchListMyFriend,
                hintStyle: TextStyle(
                  fontSize: 20.w,
                  color: ColorConstants.neutralLight80,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SvgPicture.asset(
                    Assets.icons.search,
                    color: ColorConstants.neutralLight80,
                    height: 10.w,
                    width: 10.w,
                  ),
                ),
                contentPadding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: ColorConstants.neutralLight90,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: ColorConstants.neutralLight110,
                    width: 1,
                  ),
                ),
              ),
              onChanged: (value) {
                _searchController.text = value;
              },
            ),
          ),
          checkColorList != true
              ? Container(
                  margin: EdgeInsets.only(
                    top: 20.h,
                    left: 20.w,
                    right: 20.w,
                  ),
                  padding: EdgeInsets.only(
                    top: 10.h,
                    left: 12.w,
                    right: 12.w,
                    bottom: 10.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorConstants.neutralLight80,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      ListMyFriend(
                        users: widget.friendsUsers,
                        setExpanded: setExpandedMyFriend,
                        isExpanded: isExpandedMyFriend,
                        keySearch: checkColorList == !true
                            ? _searchController.text
                            : "",
                      ),
                      if(widget.friendsUsers.length>3)
                        Padding(
                        padding: EdgeInsets.all(6.w),
                        child: InkWell(
                          onTap: setExpandedMyFriend,
                          child: isExpandedMyFriend
                              ? SvgPicture.asset(
                                  Assets.icons.upSVG,
                                  width: 13.w,
                                  height: 13.w,
                                  color: ColorConstants.neutralLight80,
                                )
                              : SvgPicture.asset(
                                  Assets.icons.downSVG,
                                  width: 13.w,
                                  height: 13.w,
                                  color: ColorConstants.neutralLight80,
                                ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                    top: 20.h,
                    left: 20.w,
                    right: 20.w,
                  ),
                  padding: EdgeInsets.only(
                    top: 10.h,
                    left: 12.w,
                    right: 12.w,
                    bottom: 10.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorConstants.neutralLight80,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      ListFriendSuggestions(
                        users: widget.friendProposals,
                        setExpanded: setExpandedFriendProposals,
                        isExpanded: isExpandedFriendProposals,
                        keySearch: checkColorList == true
                            ? _searchController.text
                            : "",
                      ),
                      if(widget.friendProposals.length>3)
                        Padding(
                        padding: EdgeInsets.all(6.w),
                        child: InkWell(
                          onTap: setExpandedFriendProposals,
                          child: isExpandedFriendProposals
                              ? SvgPicture.asset(
                                  Assets.icons.upSVG,
                                  width: 12.w,
                                  height: 12.w,
                                  color: ColorConstants.neutralLight80,
                                )
                              : SvgPicture.asset(
                                  Assets.icons.downSVG,
                                  width: 12.w,
                                  height: 12.w,
                                  color: ColorConstants.neutralLight80,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class TabBarMyFriend extends StatelessWidget {
  const TabBarMyFriend({
    super.key,
    required this.title,
    required this.checkColor,
    required this.toggleColor,
  });

  final bool checkColor;
  final String title;
  final VoidCallback toggleColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: toggleColor,
        child: Container(
          padding: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: checkColor
                ? AppColors.of(context).primaryColor9
                  : AppColors.of(context).primaryColor1,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 25.w,
              color: checkColor
                  ? AppColors.of(context).primaryColor1
                  : AppColors.of(context).neutralColor7,
            ),
          ),
        ),
      ),
    );
  }
}
