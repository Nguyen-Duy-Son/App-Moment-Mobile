import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/views/auth/login/login_view.dart';
import 'package:hit_moments/app/views/auth/register/register_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 24.w, top: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(Assets.images.authPNG),
                      SizedBox(height: 16.h,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Xin chào!",
                            style: AppTextStyles.of(context).bold32.copyWith(
                                color: AppColors.of(context).neutralColor12
                            ),),
                          Text("Bạn đã có tài khoản chưa?",
                            style: AppTextStyles.of(context).light20.copyWith(
                                color: AppColors.of(context).neutralColor11
                            ),)
                        ],
                      )
                    ],
                  )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
                child: Column(
                  children: [
                    ScaleOnTapWidget(
                      onTap: (isSelect) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginView(),));
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.of(context).primaryColor10,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
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
                          "Đăng nhập",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.of(context).regular32.copyWith(
                            color: AppColors.of(context).neutralColor1
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h,),
                    ScaleOnTapWidget(
                      onTap: (isSelect) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => RegisterView(),));
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.of(context).primaryColor2,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          border: Border.all(
                            width: 2,
                            color: AppColors.of(context).primaryColor9
                          ),
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
                          "Đăng ký",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.of(context).regular32.copyWith(
                            color: AppColors.of(context).primaryColor9
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(),
            ],
          ),
        )
    );
  }
}
