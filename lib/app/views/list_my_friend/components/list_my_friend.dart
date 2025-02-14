import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../custom/widgets/search_data_not_found.dart';
import '../../../l10n/l10n.dart';
import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';
import 'my_friend_information/my_friend_infomation.dart';

class ListMyFriend extends StatefulWidget {
  const ListMyFriend({
    super.key,
    required this.setExpanded,
    required this.isExpanded,
  });

  final VoidCallback setExpanded;

  // final VoidCallback setDownUp;

  final bool isExpanded;

  @override
  State<ListMyFriend> createState() => _ListMyFriendState();
}

class _ListMyFriendState extends State<ListMyFriend> {
  List<int> options = [0, 1, 2];
  bool isTextNotEmpty = false;
  String? searchValue;
  bool isSearch = true;
  bool isCheckText = false;
  bool isCheckInput = false;

  final TextEditingController _searchController = TextEditingController();

  void searchFriendByEmail() async {
    if (_searchController.text.isNotEmpty) {
      if (!Provider.of<UserProvider>(context, listen: false).isSearchFriend) {
        Provider.of<UserProvider>(context, listen: false)
            .getFriendUserByEmail(_searchController.text);
        if (Provider.of<UserProvider>(context, listen: false)
            .friendList
            .isEmpty) {
          setState(() {
            isSearch = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<UserProvider>().getFriendOfUser();
    _searchController.addListener(() {
      setState(() {
        isTextNotEmpty = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: S.of(context).searchListMyFriend,
                    hintStyle: AppTextStyles.of(context).light20.copyWith(
                          color: AppColors.of(context).neutralColor11,
                        ),
                    suffixIcon: isTextNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                isTextNotEmpty = false;
                              });
                              context.read<UserProvider>().getFriendOfUser();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: SvgPicture.asset(
                                Assets.icons.delete,
                                color: AppColors.of(context).neutralColor11,
                                height: 10.w,
                                width: 10.w,
                              ),
                            ),
                          )
                        : null,
                    contentPadding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppColors.of(context).neutralColor8,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AppColors.of(context).neutralColor10,
                        width: 1,
                      ),
                    ),
                  ),
                  onTap: () => searchValue,
                  onChanged: (value) {
                    _searchController.text = value;
                    setState(() {
                      isCheckText = true;
                    });
                  },
                  onFieldSubmitted: (value) {
                    searchFriendByEmail();
                  },
                ),
                if (isCheckInput)
                  Text(S.of(context).titleNofriend,
                      style: AppTextStyles.of(context).light20.copyWith(
                            color: ColorConstants.accentRed,
                          )),
              ],
            ),
          ),
          !context.watch<UserProvider>().isLoandingFriendList
              ? (context.watch<UserProvider>().friendList.isNotEmpty
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
                          color: AppColors.of(context).neutralColor8,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: isSearch == true
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.isExpanded
                                  ? context
                                      .watch<UserProvider>()
                                      .friendList
                                      .length
                                  : (context
                                              .watch<UserProvider>()
                                              .friendList
                                              .length >
                                          3
                                      ? 3
                                      : context
                                          .watch<UserProvider>()
                                          .friendList
                                          .length),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MyFriendInfomationScreen(
                                              user: context
                                                  .watch<UserProvider>()
                                                  .friendList[index],
                                              option: options[1],
                                            ),
                                          ),
                                        );
                                      },
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          context
                                              .watch<UserProvider>()
                                              .friendList[index]
                                              .avatar!,
                                          height: 36.w,
                                          width: 36.w,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width: 36.w,
                                                height: 36.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.w),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            context
                                                .watch<UserProvider>()
                                                .friendList[index]
                                                .fullName,
                                            style: AppTextStyles.of(context)
                                                .light20
                                                .copyWith(
                                                  color: AppColors.of(context)
                                                      .neutralColor12,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SvgPicture.asset(
                                            Assets.icons.rightArrow,
                                            width: 22.w,
                                            height: 22.h,
                                            color: AppColors.of(context)
                                                .neutralColor10,
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
                                        color: AppColors.of(context)
                                            .neutralColor11,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : const SearchDataNotFound(),
                    )
                  : const SearchDataNotFound())
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
                      color: AppColors.of(context).neutralColor8,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const CircularProgressIndicator(),
                )
        ],
      ),
    );
  }
}
