import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:provider/provider.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.sendto,
                style: AppTextStyles.of(context)
                    .regular32
                    .copyWith(color: AppColors.of(context).neutralColor12),
              ),
              const SizedBox(width: 35),
            ],
          ),
        ),
        body: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(imagePath),
                        width: 400.w,
                        height: 470.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          top: 25),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor6,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(1, 1),
                                color: Colors.black45)
                          ],
                        ),
                        child: TextField(
                          style: const TextStyle(fontSize: 24),
                          decoration: InputDecoration.collapsed(
                              hintText: AppLocalizations.of(context)!.feel,
                              hintStyle: AppTextStyles.of(context)
                                  .light24
                                  .copyWith(
                                  color:
                                  AppColors.of(context).neutralColor10)),
                        ), // TODO: Cảm nghĩ...
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () async {},
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(70, 70),
                    backgroundColor: AppColors.of(context).neutralColor6,
                    shape: const CircleBorder(),
                    side: BorderSide(
                        color: AppColors.of(context).primaryColor10, width: 4),
                    padding: const EdgeInsets.fromLTRB(4, 6, 12, 2),
                  ),
                  child: SvgPicture.asset(
                    Assets.icons.sendSVG,
                    height: 60.w,
                    width: 60.w,
                    color: AppColors.of(context).neutralColor12,
                  ),
                ), // TODO: Gửi đến...
                IconButton(
                  onPressed: () {
                    print('Đã ấn');
                    context.read<MomentProvider>().createMoment(
                        'Đang thử lần đầu', 'Nắng lắm', File(imagePath));
                  },
                  icon: SvgPicture.asset(Assets.icons.download2SVG),
                ) // TODO: Lưu vào máy
              ],
            )
          ],
        ),
      ),
    );
  }
}
