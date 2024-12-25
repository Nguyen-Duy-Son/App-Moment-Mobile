import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/enum/load_status.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/core/validators/validators.dart';
import 'package:hit_moments/app/custom/widgets/app_bar_widget.dart';
import 'package:hit_moments/app/custom/widgets/app_snack_bar.dart';
import 'package:hit_moments/app/custom/widgets/custom_dialog.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:hit_moments/app/views/auth/input_textff_widget.dart';

import 'cubit/forgot_password_cubit.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailOrPhoneController;
  late ForgotPasswordCubit _cubit;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = BlocProvider.of<ForgotPasswordCubit>(context);
    emailOrPhoneController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailOrPhoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: S.of(context).forgot,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 28.h),
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              Assets.images.authPNG,
                              height: MediaQuery.of(context).size.height / 4,
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                          ],
                        )),
                    InputTextffWidget(
                      controller: emailOrPhoneController,
                      hintText: S.of(context).enterEmailAddressPhoneNumber,
                      context: context,
                      // onChanged: (value) => _updateButtonColor(),
                      onSaved: (newValue) =>
                          emailOrPhoneController.text = newValue ?? "",
                      labelText: "Email",
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).cannotBeEmpty;
                        }
                        if (Validator.validateEmail(value) &&
                            value.isNotEmpty) {
                          return S.of(context).validateEmail;
                        }
                        return null;
                      },
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return newValue.copyWith(
                            text: newValue.text.toLowerCase(),
                          );
                        }),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9@.]')),
                      ],
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
                      listener: (context, state) {
                        if (state.sendVerifyEmailStatus == LoadStatus.FAILURE) {
                          _showError(state.msgSendVerifyEmail ?? "");
                        }
                        if (state.sendVerifyEmailStatus == LoadStatus.SUCCESS) {
                          Navigator.pushNamed(
                              context, AppRoutes.VERIFY_OTP);
                          AppSnackBar.showSuccess(
                            context,
                            state.msgSendVerifyEmail ?? "",
                          );
                        }
                      },
                      listenWhen: (previous, current) =>
                          previous.sendVerifyEmailStatus !=
                          current.sendVerifyEmailStatus,
                      child: ScaleOnTapWidget(
                        onTap: (isSelect) {
                          _submit();
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.of(context).primaryColor10,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.of(context).neutralColor8,
                                    spreadRadius: 1.h,
                                    blurRadius: 2.h,
                                    offset: Offset(0, 4.h))
                              ]),
                          child: Text(
                            S.of(context).next,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.of(context).regular32.copyWith(
                                color: AppColors.of(context).neutralColor1),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() == true) {
      _cubit.sendVerifyEmail(emailOrPhoneController.text);
    }
  }

  void _showError(String message) {
    showCustomDialog(
      context,
      title: S.of(context).error,
      content: Text(
        message,
        style: AppTextStyles.of(context)
            .regular24
            .copyWith(color: AppColors.of(context).neutralColor12),
        textAlign: TextAlign.center,
      ),
      backgroundPositiveButton: AppColors.of(context).primaryColor10,
      textPositive: S.of(context).ok,
      onPressPositive: () {
        Navigator.of(context).pop();
      },
      colorTextPositive: AppColors.of(context).neutralColor12,
      hideNegativeButton: true,
    );
  }
}
