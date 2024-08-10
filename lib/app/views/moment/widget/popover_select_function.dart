import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';

import '../../../core/extensions/theme_extensions.dart';
import '../../../l10n/l10n.dart';

class PopoverSelectFunction extends StatelessWidget {
   PopoverSelectFunction({
    super.key,
    required this.options,
    required this.opTap,
    required this.userIDOfMoment,
  });

  final List<Map<String, dynamic>> options;
  final void Function(String) opTap;
  final String userIDOfMoment;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredOptions = userIDOfMoment == getUserID()
        ? options.where((option) => option["menu"] == S.of(context).download || option["menu"] == S.of(context).deletePost).toList()
        : options.where((option) => option["menu"] == S.of(context).download || option["menu"] == S.of(context).hidePost || option["menu"] == S.of(context).report).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: filteredOptions.map((selectedOption) {
            return Column(
              children: [
                ScaleOnTapWidget(
                  child: SizedBox(
                    child: Row(
                      children: [
                        SizedBox(width: 16.w),
                        Text(
                          selectedOption["menu"] ?? "",
                          style: AppTextStyles.of(context).light20.copyWith(
                            color: AppColors.of(context).neutralColor11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: (isSelect) {
                    opTap(selectedOption["menu"] ?? "");
                    Navigator.pop(context, selectedOption);
                  },
                ),
                if (filteredOptions.indexOf(selectedOption) < filteredOptions.length - 1)
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
