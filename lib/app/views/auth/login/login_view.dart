import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:hit_moments/app/views/auth/login/login_widget.dart';
import 'package:hit_moments/app/views/example/home_view.dart';
import 'package:hit_moments/app/views/onboarding/onboarding_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



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
      ],
    );
  }
}
