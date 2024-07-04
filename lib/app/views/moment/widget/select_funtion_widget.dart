import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/views/moment/widget/popover_select_function.dart';
import 'package:popover/popover.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../custom/widgets/icon_on_tap_scale.dart';

class SelectFuntionWidget extends StatefulWidget {
  const SelectFuntionWidget({super.key});

  @override
  State<SelectFuntionWidget> createState() => _SelectFuntionWidgetState();
}

class _SelectFuntionWidgetState extends State<SelectFuntionWidget> {
  @override
  Widget build(BuildContext context) {
    return IconOnTapScale(
      icon1Path: Assets.icons.burgerSVG,
      icon2Path: Assets.icons.closeSVG,
      icon2Color: AppColors.of(context).primaryColor9,
      padding: 3.w,
      backGroundColor: AppColors.of(context).neutralColor1,
      icon1Color: AppColors.of(context).neutralColor9,
      iconHeight: 28.w, iconWidth: 28.w,
      onPress: () {
        showPopover(
          context: context,
          bodyBuilder: (context) =>
              PopoverSelectFunction(options: const [
                {'menu': 'Tải xuống'},
                {'menu': 'Xoá bài đăng'},
                {'menu': 'Ẩn bài đăng'}],
              ),
          onPop: () => print("Đã ấn"),
          direction: PopoverDirection.bottom,
          width: 150.w
        );
      },
    );
  }
}
