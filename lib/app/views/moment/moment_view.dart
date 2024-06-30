import 'package:flutter/material.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/icon_on_tap_scale.dart';
import 'package:hit_moments/app/views/moment/moment_widget.dart';
import 'package:hit_moments/app/views/moment/widget/dialog_select_friend.dart';
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
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: IconOnTapScale(
              icon1Path: 'assets/icons/Plus.svg',
              backGroundColor: AppColors.of(context).neutralColor6,
              icon1Color: AppColors.of(context).neutralColor6,
              iconHeight: 15,
              iconWidth: 15,
              onPress: () {

              },
            )
          ),
          backgroundColor: Colors.white,
          title: SelectFriendWidget(),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: IconOnTapScale(
                  icon1Path: 'assets/icons/Layers.svg',
                  backGroundColor: AppColors.of(context).neutralColor6,
                  icon1Color: AppColors.of(context).neutralColor6,
                  iconHeight: 20, iconWidth: 20,
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
