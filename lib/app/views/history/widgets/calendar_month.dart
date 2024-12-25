import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';

class CustomGridWidget extends StatelessWidget {
  const CustomGridWidget({super.key, required this.totalDay, required this.month, required this.monthYear});
  final int totalDay;
  final int month;
  final String monthYear;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      width: 1.sw,
      // height: 100.h,
      decoration: BoxDecoration(
        color: AppColors.of(context).neutralColor12,
        borderRadius: BorderRadius.circular(16.w),
      ),
      margin: EdgeInsets.only(bottom: 16.w),
      child: Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              monthYear,
              style: AppTextStyles.of(context).regular16.copyWith(
                color: AppColors.of(context).neutralColor1,
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: totalDay,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50.w),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
