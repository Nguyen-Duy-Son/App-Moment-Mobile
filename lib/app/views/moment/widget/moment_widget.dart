import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/format_time_extension.dart';
import 'package:hit_moments/app/custom/widgets/icon_on_tap_scale.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/models/moment_model.dart';
import 'package:hit_moments/app/views/moment/widget/bottom_sheet_input.dart';
import 'package:hit_moments/app/views/moment/widget/moment_content_widget.dart';
import 'package:hit_moments/app/views/moment/widget/select_funtion_widget.dart';
import '../../../core/extensions/theme_extensions.dart';

class MomentWidget extends StatefulWidget {
  const MomentWidget({super.key, required this.momentModel});
  final MomentModel momentModel;

  @override
  State<MomentWidget> createState() => _MomentWidgetState();
}

class _MomentWidgetState extends State<MomentWidget> {
  void showBottomSheetInput(){
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BottomSheetInput(fullName: widget.momentModel.userName??""),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xffffffff),
            Color(0xffeeeeec),
            Color(0xffDDDDDA),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                    width: 0.1,
                    color: AppColors.of(context).neutralColor10
                ),
              ),
              child: MomentContentWidget(momentModel: widget.momentModel)
          ),
          Row(
            children: [
              Expanded(
                  child: ScaleOnTapWidget(
                    onTap: (isSelect) {
                      showBottomSheetInput();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.only(top: 6.w, bottom: 2.w, left: 24.w, right: 24.w),
                      decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor1,
                          border: Border.all(
                            width: 1.w,
                            color: AppColors.of(context).primaryColor10
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(100))
                      ),
                      child: Text("Viết bình luận...",
                        style: AppTextStyles.of(context).light20.copyWith(
                          color: AppColors.of(context).neutralColor8
                        ),
                      ),
                    ),
                  )
              ),
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
                          iconHeight: 28.w, iconWidth: 28.w,
                          borderColor: AppColors.of(context).primaryColor10,
                          onPress: () {

                          },
                        ),
                        IconOnTapScale(
                          icon1Path: Assets.icons.sendSVG,
                          icon2Color: AppColors.of(context).primaryColor9,
                          backGroundColor: AppColors.of(context).neutralColor1,
                          icon1Color: AppColors.of(context).neutralColor9,
                          iconHeight: 28.w, iconWidth: 28.w,
                          borderColor: AppColors.of(context).primaryColor10,
                          onPress: () {

                          },
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
              child: SvgPicture.asset(Assets.icons.downOutLineSolidSVG,
                color: AppColors.of(context).neutralColor12,),
          )
        ],
      ),
    );
  }
}
