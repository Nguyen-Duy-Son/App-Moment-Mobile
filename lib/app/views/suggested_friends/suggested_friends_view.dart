import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/views/suggested_friends/widget/suggested_user_item_widget.dart';

import '../../core/constants/assets.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../l10n/l10n.dart';

class SuggestedFriendsView extends StatefulWidget {
  const SuggestedFriendsView({super.key});

  @override
  State<SuggestedFriendsView> createState() => _SuggestedFriendsViewState();
}

class _SuggestedFriendsViewState extends State<SuggestedFriendsView> {
  int listLength =3;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.of(context).neutralColor1,
            automaticallyImplyLeading: false,
            title: SvgPicture.asset(Assets.icons.up2SVG,
              color: AppColors.of(context).neutralColor12,),
            centerTitle: true,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                                  child: SvgPicture.asset(Assets.icons.search)
                                ),
                              ),
                            ),
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
                          child: listLength==0
                              ?Container(
                            child: Column(
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
                            ),
                          )
                              :ListView.builder(
                            itemCount: listLength,
                              itemBuilder: (context, index) {
                                return SuggestedUserItemWidget(
                                  index: index,
                                  listLength: listLength,
                                );
                              },
                          )
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
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
