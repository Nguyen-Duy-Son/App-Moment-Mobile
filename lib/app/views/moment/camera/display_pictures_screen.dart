// app/views/moment/camera/display_pictures_screen.dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> _showWeather = ValueNotifier(false);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.sendto,
                style: AppTextStyles.of(context).regular32.copyWith(
                color: AppColors.of(context).neutralColor12,),
              ),
              const SizedBox(width: 35,)
            ],
          )
        ),
        body: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(File(imagePath), width: 400, height: 470, fit: BoxFit.fill),
                    ),
                    SingleChildScrollView(
                      reverse: true,
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(50, 0, 50, 25),
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor6,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(1, 1),
                              color: Colors.black45
                            )
                          ]
                        ),
                        child: TextField(
                          decoration: InputDecoration.collapsed(hintText: AppLocalizations.of(context)!.feel, hintStyle: AppTextStyles.of(context).light24.copyWith(color: AppColors.of(context).neutralColor10))
                        ), //TODO: Cảm nghĩ...
                      ), 
                    ),
                  ],
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _showWeather, 
                  builder: (context, value, child) {
                    return value ? Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Stack(
                        children: [
                          Container(
                            width: 130, height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.of(context).neutralColor9,
                            ),
                          ),
                          Positioned(left: 0, top: 0,
                            child: ClipRRect( 
                              child: BackdropFilter(
                                filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 0, tileMode: ui.TileMode.mirror),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: 130, height: 50,
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(Assets.icons.sunSVG, width: 40, height: 40,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Hà Nội', style: AppTextStyles.of(context).light16.copyWith(color: AppColors.of(context).neutralColor3, fontSize: 14)),
                                          Text('29°C', style: AppTextStyles.of(context).regular20.copyWith(color: AppColors.of(context).neutralColor3, fontSize: 20))
                                        ],
                                      ),
                                      const SizedBox(height: 10)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                    ) : const SizedBox();
                  })
              ],
            ),
            const SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _showWeather,
                  builder: (context, value, child) {
                    return IconButton(
                      onPressed: () {
                        _showWeather.value = !_showWeather.value;
                      },
                      icon: SvgPicture.asset(value ? Assets.icons.cloud2SVG : Assets.icons.cloud1SVG)
                    );
                  },
                ), //TODO: Thêm thời tiết
                OutlinedButton(
                    onPressed: () async {},
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(70, 70),
                      backgroundColor: AppColors.of(context).neutralColor6,
                      shape: const CircleBorder(),
                      side: BorderSide(color: AppColors.of(context).primaryColor10, width: 4),
                      padding: const EdgeInsets.fromLTRB(4, 6, 12, 2)
                    ),
                    child: SvgPicture.asset(Assets.icons.sendSVG, height: 60, width: 60, color: AppColors.of(context).neutralColor12,),
                  ), //TODO: Gửi đến...
                IconButton(
                  onPressed: () {}, 
                  icon: SvgPicture.asset(Assets.icons.download2SVG)) //TODO: Lưu vào may
              ],
            )
          ]
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
    @override
    Path getClip(Size size) {
      var path = Path();
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
      path.close();
      return path;
    }
    @override
    bool shouldReclip(CustomClipper<Path> oldClipper) {
      return false;
    }
  }