import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/app_bar_animation.dart';
import 'package:hit_moments/app/views/auth/register/register_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/config/enum.dart';
import '../../../core/constants/assets.dart';
import '../../../l10n/l10n.dart';
import '../../../providers/auth_provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                  icon: SvgPicture.asset(Assets.icons.leftSVG),
                  onPressed: () => Navigator.of(context).pop()),
                title: Text(
                  S.of(context).register,
                  style: AppTextStyles.of(context)
                      .regular32
                      .copyWith(color: AppColors.of(context).neutralColor12),
                ),
              ),
              body: const RegisterWidget(),
            ),
            context.watch<AuthProvider>().registerStatus == ModuleStatus.loading
                ?const Opacity(
              opacity: 0.6,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ):const SizedBox(),
            context.watch<AuthProvider>().registerStatus == ModuleStatus.loading
                ?const Center(
              child: AppPageWidget(),
            ):const SizedBox(),
          ],
        )
    );
  }
}
