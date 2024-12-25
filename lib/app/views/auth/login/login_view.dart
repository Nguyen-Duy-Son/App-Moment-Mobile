import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/app_bar_animation.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: SvgPicture.asset(Assets.icons.leftSVG),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              S.of(context).login,
              style: AppTextStyles.of(context).regular32.copyWith(color: AppColors.of(context).neutralColor12),
            ),
            centerTitle: true,
          ),
          body: const SafeArea( child: LoginWidget()),
        ),
        context.watch<AuthProvider>().loginStatus == ModuleStatus.loading
            ? const Center(
                child: AppPageWidget(),
              )
            : const SizedBox(),
      ],
    );
  }
}
