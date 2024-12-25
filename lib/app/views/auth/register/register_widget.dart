import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/utils/date.dart';
import 'package:hit_moments/app/custom/widgets/app_snack_bar.dart';
import 'package:hit_moments/app/custom/widgets/custom_dialog.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:hit_moments/app/views/auth/login/login_view.dart';
import 'package:hit_moments/app/views/auth/register/verify_email_view.dart';
import 'package:provider/provider.dart';

import '../../../core/config/enum.dart';
import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../custom/widgets/scale_on_tap_widget.dart';
import '../../../l10n/l10n.dart';
import '../../../providers/auth_provider.dart';
import '../input_textff_widget.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  String? _successful;
  bool _isFullField = false;
  bool _obscurePass = true;
  bool _obscurePassConfirm = true;

  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>().setData(false);
  }

  void _updateButtonColor() {
    if (_emailController.text.isEmpty ||
        _fullNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _dateOfBirthController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordConfirmController.text.isEmpty) {
      _isFullField = false;
      context.read<AuthProvider>().fullFieldRegister(false);
    } else {
      if (!_isFullField) {
        _isFullField = true;
        context.read<AuthProvider>().fullFieldRegister(true);
      }
    }
  }

  Future<void> _submit() async {
    final form = _formKey.currentState!;

    if (form.validate()) {
      form.save();
      form.validate();
      await context.read<AuthProvider>().register(
          _fullNameController.text,
          _phoneNumberController.text,
          _dateOfBirthController.text,
          _emailController.text,
          _passwordConfirmController.text,
          context);
      if (Provider.of<AuthProvider>(context, listen: false).registerStatus ==
          ModuleStatus.success) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginView(),
            ),
            ModalRoute.withName(AppRoutes.LOGIN));
        AppSnackBar.showSuccess(context, S.of(context).registerSuccess);
      }
    }
    if(Provider.of<AuthProvider>(context, listen: false).registerStatus == ModuleStatus.fail){
      _showError(context.watch<AuthProvider>().registerSuccess ??'');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputTextffWidget(
                    controller: _fullNameController,
                    hintText: S.of(context).fullName,
                    context: context,
                    validator: (value) =>
                        value!.isEmpty ? S.of(context).cannotBeEmpty : null,
                    onChanged: (value) => _updateButtonColor(),
                    onSaved: (newValue) =>
                        _fullNameController.text = newValue ?? "",
                    labelText: S.of(context).fullName,
                    isRequired: true,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  InputTextffWidget(
                    controller: _phoneNumberController,
                    hintText: S.of(context).phoneNumber,
                    context: context,
                    validator: (value) =>
                        value!.isEmpty ? S.of(context).cannotBeEmpty : null,
                    onChanged: (value) => _updateButtonColor(),
                    onSaved: (newValue) =>
                        _phoneNumberController.text = newValue ?? "",
                    labelText: S.of(context).phoneNumber,
                    isRequired: true,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  InputTextffWidget(
                    controller: _dateOfBirthController,
                    hintText: "dd/mm/yyyy",
                    isReadOnly: true,
                    context: context,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.of(context).neutralColor8,
                        ),
                      ),
                    validator: (value) =>
                        value!.isEmpty ? S.of(context).cannotBeEmpty : null,
                    onChanged: (value) => _updateButtonColor(),
                    onSaved: (newValue) =>
                        _dateOfBirthController.text = newValue ?? "",
                    labelText: S.of(context).dateOfBirth,
                    isRequired: false,
                    suffixIcon: GestureDetector(
                      child: SvgPicture.asset(
                        "assets/icons/ic_calendar.svg",
                        color: AppColors.of(context).neutralColor9,
                        width: 24.w,
                        height: 24.w,
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _dateOfBirthController.text =
                                formatTimestampDayMonthOnly(picked);
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  InputTextffWidget(
                    controller: _emailController,
                    hintText: 'Email',
                    context: context,
                    validator: (value) => !value!.contains('@')
                        ? S.of(context).emailNotValid
                        : null,
                    onChanged: (value) => _updateButtonColor(),
                    onSaved: (newValue) =>
                        _emailController.text = newValue ?? "",
                    errorText: context.watch<AuthProvider>().emailExist,
                    labelText: "Email",
                    isRequired: true,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  InputTextffWidget(
                    controller: _passwordController,
                    hintText: S.of(context).password,
                    context: context,
                    validator: (value) {
                      if (value!.length < 8 ||
                          !RegExp(r'[A-Za-z]').hasMatch(value) ||
                          !RegExp(r'\d').hasMatch(value)) {
                        return S.of(context).passwordRequirement;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _updateButtonColor();
                    },
                    onSaved: (newValue) =>
                        _passwordController.text = newValue ?? "",
                    obscureText: _obscurePass,
                    labelText: S.of(context).password,
                    isRequired: true,
                    suffixIcon: GestureDetector(
                      child: SvgPicture.asset(
                        _obscurePass
                            ? "assets/icons/ic_eye_close.svg"
                            : "assets/icons/ic_eye.svg",
                        color: AppColors.of(context).neutralColor9,
                        width: 24.w,
                        height: 24.w,
                      ),
                      onTap: () {
                        setState(() {
                          _obscurePass = !_obscurePass;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  InputTextffWidget(
                    controller: _passwordConfirmController,
                    hintText: S.of(context).confirmPassword,
                    context: context,
                    validator: (value) => _passwordConfirmController.text !=
                            _passwordController.text
                        ? S.of(context).notMatched
                        : null,
                    onChanged: (value) {
                      _updateButtonColor();
                    },
                    onSaved: (newValue) =>
                        _passwordConfirmController.text = newValue ?? "",
                    obscureText: _obscurePassConfirm,
                    labelText: S.of(context).confirmPassword,
                    isRequired: true,
                    suffixIcon: GestureDetector(
                      child: SvgPicture.asset(
                        _obscurePassConfirm
                            ? "assets/icons/ic_eye_close.svg"
                            : "assets/icons/ic_eye.svg",
                        color: AppColors.of(context).neutralColor9,
                        width: 24.w,
                        height: 24.w,
                      ),
                      onTap: () {
                        setState(() {
                          _obscurePassConfirm = !_obscurePassConfirm;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 32.w, top: 32.h, right: 32.w, bottom: 16.h),
            child: context.watch<AuthProvider>().isFullFieldRegister
                ? ScaleOnTapWidget(
                    onTap: (isSelect) {
                      _submit();
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
                                offset: Offset(0, 4.h))
                          ]),
                      child: Text(
                        S.of(context).register,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.of(context).regular32.copyWith(
                            color: AppColors.of(context).neutralColor1),
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.of(context).neutralColor7,
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
                      S.of(context).register,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.of(context).regular32.copyWith(
                          color: AppColors.of(context).neutralColor11),
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).alreadyHaveAnAccount,
                style: AppTextStyles.of(context).light16.copyWith(
                    color: AppColors.of(context).neutralColor12,
                    fontWeight: FontWeight.w400),
              ),
              ScaleOnTapWidget(
                onTap: (isSelect) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                      ModalRoute.withName(AppRoutes.LOGIN));
                },
                child: Text(
                  S.of(context).login,
                  style: AppTextStyles.of(context).light16.copyWith(
                      color: AppColors.of(context).primaryColor10,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 32.h,
          )
        ],
      ),
    );
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
