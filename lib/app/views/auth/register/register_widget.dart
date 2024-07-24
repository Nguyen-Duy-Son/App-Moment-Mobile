import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final TextEditingController _passwordConfirmController = TextEditingController();
  String? _successful;
  bool _isFullField = false;
  bool _obscurePass = true;
  bool _obscurePassConfirm = true;

  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>().setData(false);
  }

  void _updateButtonColor(){
    if(_emailController.text.isEmpty ||
        _fullNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _dateOfBirthController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordConfirmController.text.isEmpty){
      _isFullField = false;
      context.read<AuthProvider>().fullFieldRegister(false);
    }else{
      if(!_isFullField){
        _isFullField = true;
        context.read<AuthProvider>().fullFieldRegister(true);
      }
    }
  }

  Future<void> _submit() async {
    final form = _formKey.currentState!;

    if(form.validate()){
      form.save();
      form.validate();
      await context.read<AuthProvider>()
          .register(
          _fullNameController.text,
          _phoneNumberController.text,
          _dateOfBirthController.text,
          _emailController.text,
          _passwordConfirmController.text, context);
      if(context.watch<AuthProvider>().registerStatus == ModuleStatus.success){
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => const VerifyEmailView()
          ,), ModalRoute.withName(AppRoutes.VERIFYEMAIL));
      }

    }else{
      print("lỗi");
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
                    height: MediaQuery.of(context).size.height/4,),
                  SizedBox(height: 16.h,),
                ],
              )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).registerNow,
                    style: AppTextStyles.of(context).regular32.copyWith(
                        color: AppColors.of(context).neutralColor12
                    ),
                  ),
                  InputTextffWidget(
                    controller: _fullNameController,
                    hintText: S.of(context).fullName,
                    context: context,
                    validator: (value) => value!.isEmpty ? S.of(context).cannotBeEmpty : null,
                    onChanged: (value) => _updateButtonColor(),
                    onSaved: (newValue) => _fullNameController.text = newValue ?? "",
                  ),
                  InputTextffWidget(
                    controller: _phoneNumberController,
                    hintText: 'Số điện thoại',
                    context: context,
                    validator: (value) => value!.isEmpty ? S.of(context).cannotBeEmpty : null,
                    onChanged: (value) => _updateButtonColor(),
                    onSaved: (newValue) => _phoneNumberController.text = newValue ?? "",
                  ),
                  InputTextffWidget(
                    controller: _dateOfBirthController,
                    hintText: 'Ngày sinh',
                    context: context,
                    validator: (value) => value!.isEmpty ? S.of(context).cannotBeEmpty : null,
                    onChanged: (value) => _updateButtonColor(),
                    onSaved: (newValue) => _dateOfBirthController.text = newValue ?? "",
                  ),
                  InputTextffWidget(
                    controller: _emailController,
                    hintText: 'Email',
                    context: context,
                    validator: (value) => !value!.contains('@') ? S.of(context).emailNotValid : null,
                    onChanged: (value) => _updateButtonColor(),
                    onSaved: (newValue) => _emailController.text = newValue ?? "",
                    errorText: context.watch<AuthProvider>().emailExist,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: S.of(context).password,
                        hintStyle: AppTextStyles.of(context).light16.copyWith(
                            color: AppColors.of(context).neutralColor11
                        ),
                        errorStyle: TextStyle(
                          color: _successful==null ? Colors.red : Colors.green,
                        ),
                        suffixIconColor: AppColors.of(context).neutralColor9,
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscurePass?Icons.visibility_off:Icons.visibility,
                            size: 16.w,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePass = !_obscurePass;
                            });
                          },
                        )

                    ),
                    style: AppTextStyles.of(context).light20.copyWith(
                        color: AppColors.of(context).neutralColor12
                    ),
                    validator: (value) {
                      if (value!.length < 8 ||
                          !RegExp(r'[A-Za-z]').hasMatch(value) ||
                          !RegExp(r'\d').hasMatch(value)) {
                        return S.of(context).passwordRequirement;
                      }
                      return null;
                    },
                    onSaved: (newValue) => _passwordController.text = newValue??"",
                    onChanged: (value) {
                      _updateButtonColor();
                    },
                    obscureText: _obscurePass,
                  ),
                  TextFormField(
                    controller: _passwordConfirmController,
                    decoration: InputDecoration(
                        hintText: S.of(context).confirmPassword,
                        hintStyle: AppTextStyles.of(context).light16.copyWith(
                            color: AppColors.of(context).neutralColor11
                        ),
                        errorStyle: TextStyle(
                          color: context.watch<AuthProvider>().registerStatus == ModuleStatus.success? Colors.green:  Colors.red,
                        ),
                        errorText: context.watch<AuthProvider>().registerSuccess,
                        errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1,
                                color: ModuleStatus.success
                                    == context.read<AuthProvider>().registerStatus?AppColors.of(context)
                                    .neutralColor9:AppColors.of(context).primaryColor10)
                        ),
                        suffixIconColor: AppColors.of(context).neutralColor9,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassConfirm?Icons.visibility_off:Icons.visibility,
                            size: 16.w,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassConfirm = !_obscurePassConfirm;
                            });
                          },
                        )

                    ),
                    style: AppTextStyles.of(context).light20.copyWith(
                        color: AppColors.of(context).neutralColor12
                    ),
                    validator: (value) =>
                    _passwordConfirmController.text != _passwordController.text ?S.of(context).notMatched:null,
                    onSaved: (newValue) => _passwordConfirmController.text = newValue??"",
                    onChanged: (value) {
                      _updateButtonColor();
                    },
                    obscureText: _obscurePassConfirm,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 32.w, top: 32.h, right: 32.w, bottom: 16.h),
            child: context.watch<AuthProvider>().isFullFieldRegister
                ? ScaleOnTapWidget(
              onTap: (isSelect) {
                _submit();
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
                  S.of(context).register,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.of(context).regular32.copyWith(
                      color: AppColors.of(context).neutralColor1
                  ),
                ),
              ),
            )
            : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.of(context).neutralColor7,
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
                S.of(context).register,
                textAlign: TextAlign.center,
                style: AppTextStyles.of(context).regular32.copyWith(
                    color: AppColors.of(context).neutralColor11
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


