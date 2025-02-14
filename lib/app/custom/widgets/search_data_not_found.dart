// app/custom/widgets/search_data_not_found.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/color_constants.dart';

class SearchDataNotFound extends StatelessWidget {
  const SearchDataNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.of(context).neutralColor8,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.searchOff,
              width: 100.w,
              height: 100.h,
              color: ColorConstants.neutralLight100,
            ),
            Text(
              S.of(context).userNotFound,
              style: AppTextStyles.of(context).light24.copyWith(
                    color: AppColors.of(context).neutralColor11,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
