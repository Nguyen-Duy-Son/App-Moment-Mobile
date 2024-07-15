import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/providers/auth_provider.dart';
import 'package:hit_moments/app/views/auth/login/login_widget.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: SvgPicture.asset(Assets.icons.leftSVG),
                  onPressed: () => Navigator.of(context).pop(),),
              ),
              body: const LoginWidget(),
            )
        ),
        context.watch<AuthProvider>().loginStatus == ModuleStatus.loading
        ?const Opacity(
          opacity: 0.6,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ):SizedBox(),
        context.watch<AuthProvider>().loginStatus == ModuleStatus.loading
        ?const Center(
          child: CircularProgressIndicator(color: Colors.white,),
        ):SizedBox(),
      ],
    );
  }
}
