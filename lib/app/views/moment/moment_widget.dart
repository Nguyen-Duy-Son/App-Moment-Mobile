import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/custom/widgets/icon_on_tap_scale.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/views/moment/widget/select_funtion_widget.dart';

import '../../core/extensions/theme_extensions.dart';

class MomentWidget extends StatefulWidget {
  const MomentWidget({super.key});

  @override
  State<MomentWidget> createState() => _MomentWidgetState();
}

class _MomentWidgetState extends State<MomentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color(0xffffffff),
        Color(0xffeeeeec),
        Color(0xffDDDDDA),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(top: 16.w),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(width: 0.1, color: AppColors.of(context).neutralColor10),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.w),
                      child: Image.network(
                        "https://images.wallpaperscraft.com/image/single/cat_face_cool_cat_94317_1400x1050.jpg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16.w,
                    left: 16.w,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(100))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.w),
                            child: Image.network(
                              "https://image.phunuonline.com.vn/fckeditor/upload/2024/20240509/images/fan-taylor-swift-cuu-doanh-_791715219308.jpg",
                              width: 40.w,
                              height: 40.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bộ Bộ",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.of(context).regular16.copyWith(color: AppColors.of(context).neutralColor1),
                            ),
                            Text(
                              "1 giờ trước",
                              style: AppTextStyles.of(context).light14.copyWith(color: AppColors.of(context).neutralColor8),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16.w,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor6,
                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Text(
                          "Con mèo đẹp quá trời!",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.of(context).light24.copyWith(color: AppColors.of(context).neutralColor12),
                        ),
                      ),
                    ),
                  )
                ],
              )),
          Row(
            children: [
              Expanded(
                  child: ScaleOnTapWidget(
                onTap: (isSelect) {},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  padding: EdgeInsets.only(top: 6.w, bottom: 2.w, left: 24.w, right: 24.w),
                  decoration: BoxDecoration(
                      color: AppColors.of(context).neutralColor1,
                      border: Border.all(width: 1.w, color: AppColors.of(context).neutralColor9),
                      borderRadius: const BorderRadius.all(Radius.circular(100))),
                  child: Text(
                    "Viết bình luận...",
                    style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).neutralColor8),
                  ),
                ),
              )),
              Expanded(
                  child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconOnTapScale(
                      icon1Path: Assets.icons.heartOutlineSVG,
                      icon2Color: AppColors.of(context).primaryColor9,
                      icon2Path: Assets.icons.heartOrangeSVG,
                      backGroundColor: AppColors.of(context).neutralColor1,
                      icon1Color: AppColors.of(context).neutralColor9,
                      iconHeight: 28.w,
                      iconWidth: 28.w,
                      onPress: () {},
                    ),
                    IconOnTapScale(
                      icon1Path: Assets.icons.sendSVG,
                      icon2Color: AppColors.of(context).primaryColor9,
                      backGroundColor: AppColors.of(context).neutralColor1,
                      icon1Color: AppColors.of(context).neutralColor9,
                      iconHeight: 28.w,
                      iconWidth: 28.w,
                      onPress: () {},
                    ),
                    const SelectFuntionWidget()
                  ],
                ),
              ))
            ],
          ),
          const SizedBox(),
          SizedBox(
            height: 50,
            child: SvgPicture.asset(
              Assets.icons.downOutLineSolidSVG,
              color: AppColors.of(context).neutralColor12,
            ),
          )
        ],
      ),
    );
  }
}
