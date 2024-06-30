import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/custom/widgets/icon_on_tap_scale.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/views/moment/widget/dialog_select_friend.dart';

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
      decoration: BoxDecoration(
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
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                    width: 0.1,
                    color: AppColors.of(context).neutralColor10
                ),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 3/4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network("https://images.wallpaperscraft.com/image/single/cat_face_cool_cat_94317_1400x1050.jpg", fit: BoxFit.fill,),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage("https://image.phunuonline.com.vn/fckeditor/upload/2024/20240509/images/fan-taylor-swift-cuu-doanh-_791715219308.jpg"),
                            radius: 20,
                          ),
                          radius: 21,
                          backgroundColor: Colors.white
                        ),
                        SizedBox(width: 8,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bộ Bộ",
                              style: AppTextStyles.of(context).regular16.copyWith(
                                color: AppColors.of(context).neutralColor1
                              ),
                            ),
                            Text("1 giờ trước",
                            style: AppTextStyles.of(context).light14.copyWith(
                              color: AppColors.of(context).neutralColor8
                            ),)
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text("Con mèo đẹp quá trời!",
                          style: AppTextStyles.of(context).light24.copyWith(
                            color: AppColors.of(context).neutralColor12
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor6,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
          Row(
            children: [
              Expanded(
                  child: ScaleOnTapWidget(
                    onTap: (isSelect) {

                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      padding: EdgeInsets.only(top: 6, bottom: 2, left: 24, right: 24),
                      decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor1,
                          border: Border.all(
                            width: 1,
                            color: AppColors.of(context).neutralColor9
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
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconOnTapScale(
                          icon1Path: 'assets/icons/heart.svg',
                          icon2Color: AppColors.of(context).primaryColor9,
                          icon2Path: 'assets/icons/Heart-1.svg',
                          backGroundColor: AppColors.of(context).neutralColor1,
                          icon1Color: AppColors.of(context).neutralColor9,
                          iconHeight: 28, iconWidth: 28,
                          onPress: () {

                          },
                        ),
                        IconOnTapScale(
                          icon1Path: 'assets/icons/Send.svg',
                          icon2Color: AppColors.of(context).primaryColor9,
                          backGroundColor: AppColors.of(context).neutralColor1,
                          icon1Color: AppColors.of(context).neutralColor9,
                          iconHeight: 28, iconWidth: 28,
                          onPress: () {

                          },
                        ),
                        IconOnTapScale(
                          icon1Path: 'assets/icons/Burger.svg',
                          icon2Path: 'assets/icons/Close.svg',
                          icon2Color: AppColors.of(context).primaryColor9,
                          padding: 3,
                          backGroundColor: AppColors.of(context).neutralColor1,
                          icon1Color: AppColors.of(context).neutralColor9,
                          iconHeight: 28, iconWidth: 28,
                          onPress: () {

                          },
                        )
                      ],
                                  ),
                  ))
            ],
          ),
          SizedBox(),
          SizedBox(
              child: SvgPicture.asset("assets/icons/Down 2.svg",
                color: AppColors.of(context).neutralColor12,),
            height: 50,
          )
        ],
      ),
    );
  }
}
