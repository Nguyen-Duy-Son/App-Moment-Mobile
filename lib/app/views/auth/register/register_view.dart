import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/views/auth/register/register_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/config/enum.dart';
import '../../../core/constants/assets.dart';
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
                leading: IconButton(
                  icon: SvgPicture.asset(Assets.icons.leftSVG),
                  onPressed: () => Navigator.of(context).pop()),
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
              child: CircularProgressIndicator(color: Colors.white,),
            ):SizedBox(),
          ],
        )
    );
  }
}
