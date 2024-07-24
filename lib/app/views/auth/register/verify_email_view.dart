import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:hit_moments/app/views/auth/auth_view.dart';

import '../../../custom/widgets/scale_on_tap_widget.dart';
import '../../../l10n/l10n.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h
                  ),
                child: Image.asset(Assets.images.verifyEmailPNG),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Text(
                        S.of(context).verifyEmail,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.of(context).regular32.copyWith(
                            color: AppColors.of(context).neutralColor12,
                        )),
                    Text( S.of(context).thankYouForRegistering,
                        style: AppTextStyles.of(context).light20.copyWith(
                            color: AppColors.of(context).neutralColor11,
                          height: 1.h
                        ),
                      textAlign: TextAlign.center,

                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 32.w, top: 32.h, right: 32.w),
                  child: ScaleOnTapWidget(
                    onTap: (isSelect) {
                      Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context) => const AuthView()),
                      ModalRoute.withName(AppRoutes.AUTHENTICATION));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.of(context).primaryColor10,
                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.of(context).neutralColor8,
                                spreadRadius: 1.h,
                                blurRadius: 2.h,
                                offset: Offset(0, 4.h)
                            )
                          ]
                      ),
                      child: Text(
                        S.of(context).complete,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.of(context).regular32.copyWith(
                            color: AppColors.of(context).neutralColor1
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
        )
    );
  }
}
