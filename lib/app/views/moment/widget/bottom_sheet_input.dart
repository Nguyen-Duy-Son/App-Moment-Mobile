import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/models/moment_model.dart';
import 'package:hit_moments/app/models/user_model.dart';
import 'package:hit_moments/app/providers/conversation_provider.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../custom/widgets/icon_on_tap_scale.dart';

class BottomSheetInput extends StatelessWidget {
   BottomSheetInput({super.key, required this.controller, required this.momentModel});
  final TextEditingController controller;
  final MomentModel momentModel;

  Future<void> sendMessage(BuildContext context) async{
    if(controller.text.isNotEmpty){
      final momentProvider = context.read<ConversationProvider>();
      await momentProvider.sendMessage(
              momentModel.userID??"",
            "[@isImg123@]${momentModel.image}"
          );
      await momentProvider.sendMessage(
              momentModel.userID??"",
            controller.text
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              padding: EdgeInsets.only(top: 6.w, bottom: 2.w, left: 24.w, right: 16.w),
              decoration: BoxDecoration(
                color: AppColors.of(context).neutralColor1,
                border: Border.all(
                  width: 1.w,
                  color: AppColors.of(context).primaryColor10,
                ),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: TextFormField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Trả lời ${momentModel.userName}",
                  hintStyle: AppTextStyles.of(context).light20.copyWith(
                    color: AppColors.of(context).neutralColor8,
                  ),
                  border: InputBorder.none,
                  suffixIcon: ScaleOnTapWidget(
                    onTap: (isSelect) {
                      sendMessage(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                        child: SvgPicture.asset(Assets.icons.sendSVG)
                    ),
                  ),
                ),
                style: AppTextStyles.of(context).light20.copyWith(
                  color: AppColors.of(context).neutralColor11,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
