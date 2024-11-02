import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/views/auth/login/login_widget.dart';

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
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: const LoginWidget(),
          ),
        ),
        // if (loginStatus == ModuleStatus.loading) ...[
        //   const Opacity(
        //     opacity: 0.6,
        //     child: ModalBarrier(dismissible: false, color: Colors.black),
        //   ),
        //   const Center(
        //     child: CircularProgressIndicator(color: Colors.white),
        //   ),
        // ],
        // fail
        // if(loginStatus == ModuleStatus.fail) ...[
        //
        //   _showError()
        //
        // ],

        // if (loginStatus == ModuleStatus.success) ...[
        //   const Opacity(
        //     opacity: 0.6,
        //     child: ModalBarrier(dismissible: false, color: Colors.black),
        //   ),
          // const Center(
          //   child: CircularProgressIndicator(color: Colors.white),
          // ),
        // ]
      ],
    );
  }
}
