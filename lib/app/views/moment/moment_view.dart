import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/icon_on_tap_scale.dart';
import 'package:hit_moments/app/views/moment/moment_widget.dart';
import 'package:hit_moments/app/views/moment/widget/select_friend_widget.dart';

class MomentView extends StatefulWidget {
  const MomentView({super.key});

  @override
  State<MomentView> createState() => _MomentViewState();
}

class _MomentViewState extends State<MomentView> {
  int selected = 5;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.w, bottom: 8.w),
            child: IconOnTapScale(
              icon1Path: Assets.icons.plusSVG,
              backGroundColor: AppColors.of(context).neutralColor6,
              icon1Color: AppColors.of(context).neutralColor10,
              iconHeight: 15.w,
              iconWidth: 15.w,
              onPress: () {

              },
            )
          ),
          backgroundColor: Colors.white,
          title: SelectFriendWidget(),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: IconOnTapScale(
                  icon1Path: Assets.icons.layersSVG,
                  backGroundColor: AppColors.of(context).neutralColor6,
                  icon1Color: AppColors.of(context).neutralColor10,
                  iconHeight: 20.w, iconWidth: 20.w,
                  onPress: () {

                    //SelectFriendWidget();
                  },),
            )
          ],
        ),
        body: MomentWidget(),
      ),
    );
  }
}
