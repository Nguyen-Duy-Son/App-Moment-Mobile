import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/models/user_model.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:hit_moments/app/views/suggested_friends/widget/suggested_user_item_widget.dart';
import 'package:provider/provider.dart';

import '../../core/constants/assets.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../l10n/l10n.dart';

class SuggestedFriendsView extends StatefulWidget {
  const SuggestedFriendsView({super.key});

  @override
  State<SuggestedFriendsView> createState() => _SuggestedFriendsViewState();
}

class _SuggestedFriendsViewState extends State<SuggestedFriendsView> {
  List<User> listUser = [];
  late TextEditingController searchController;
  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
  }

  Future<void> getData() async{
    if(context.watch<UserProvider>().friendSuggestStatus == ModuleStatus.initial) {
      context.read<UserProvider>().getFriendSuggest();
    }
    listUser = context.watch<UserProvider>().friendSuggests;
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(Assets.icons.up2SVG,
                    color: AppColors.of(context).neutralColor12, height: 30.h,),
                  Text(
                    S.of(context).makeNewFriends,
                    style: AppTextStyles.of(context).bold32.copyWith(
                      color: AppColors.of(context).neutralColor12
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor2,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(0, 5.h),
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                          ),
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                borderSide: BorderSide(
                                  color: AppColors.of(context).neutralColor11,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                borderSide: BorderSide(
                                  color: AppColors.of(context).neutralColor11,
                                  width: 1.0,
                                ),
                              ),
                              hintText: S.of(context).searchByEmailPhone,
                              hintStyle: AppTextStyles.of(context).light16.copyWith(
                                color: AppColors.of(context).neutralColor10
                              ),
                              contentPadding: EdgeInsets.only(left: 24.w,
                                  bottom: 16.h, top: 16.h),
                              suffixIcon: ScaleOnTapWidget(
                                onTap: (isSelect) {
                                  FocusScope.of(context).unfocus();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 24.0),
                                  child: ScaleOnTapWidget(
                                    child: SvgPicture.asset(Assets.icons.search),
                                    onTap: (isSelect) {
                                      if(searchController.text.isEmpty){
                                        FocusScope.of(context).unfocus();
                                      }else{
                                        FocusScope.of(context).unfocus();
                                        context.read<UserProvider>()
                                            .searchFriendRequest(
                                            searchController.text,
                                            S.of(context).userNotFound);
                                      }
                                    },
                                  )
                                ),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              if(searchController.text.isEmpty){
                                FocusScope.of(context).unfocus();
                              }else{
                                context.read<UserProvider>()
                                    .searchFriendRequest(
                                    searchController.text,
                                    S.of(context).userNotFound);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 16.h,),
                        Container(
                          height: MediaQuery.of(context).size.height/3,
                          width: double.maxFinite,
                          padding: EdgeInsets.all(16.h),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor2,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(0, 5.h),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.of(context).neutralColor11,
                              width: 1.0
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: context.watch<UserProvider>().friendSuggestStatus == ModuleStatus.loading?
                          Center(
                            child: CircularProgressIndicator(),
                          ):
                          context.watch<UserProvider>().friendSuggestStatus == ModuleStatus.fail
                              ?Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(Assets.icons.searchNotFound),
                                  Text(
                                    S.of(context).userNotFound,
                                    style: AppTextStyles.of(context).regular20.copyWith(
                                        color: AppColors.of(context).neutralColor12
                                    ),
                                  )
                                ],
                              )
                              :ListView.builder(
                            itemCount: listUser.length,
                            itemBuilder: (context, index) {
                              return SuggestedUserItemWidget(
                                index: index,
                                user: listUser[index],
                                listLength: listUser.length,
                              );
                            },
                          )
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Image.asset(Assets.images.suggestedFriendsPNG),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
