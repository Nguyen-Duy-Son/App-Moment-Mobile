import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';

import '../../../core/extensions/theme_extensions.dart';

class PopoverSelectFunction extends StatelessWidget {
  const PopoverSelectFunction({super.key, required this.options});
  final List<Map<String, dynamic>> options;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((selectedOption) {
            return Column(
              children: [
                ScaleOnTapWidget(
                  child: SizedBox(
                    child: Row(
                      children: [
                        SizedBox(width: 16.w,),
                        Text(
                          selectedOption["menu"]??"",
                          style: AppTextStyles.of(context).light20.copyWith(
                              color: AppColors.of(context).neutralColor11
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: (isSelect) {
                    Navigator.pop(context, selectedOption);
                  },
                ),
                if (options.indexOf(selectedOption) < options.length - 1)
                  Divider(
                    color: Colors.grey,
                    height: ScreenUtil().setHeight(1.0),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
