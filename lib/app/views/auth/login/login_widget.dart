import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/providers/auth_provider.dart';
import 'package:hit_moments/app/views/example/example_view.dart';
import 'package:provider/provider.dart';

import '../../../core/config/enum.dart';
import '../../../core/constants/assets.dart';
import '../../../custom/widgets/scale_on_tap_widget.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isFullField = false;

  @override
  void initState() {
    super.initState();
    // _emailController.text = getEmail();
    // _passwordController.text = getPassWord();
    _emailController.text = 'admin@hitmoments.com';
    _passwordController.text = 'admin';
    if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
      context.read<AuthProvider>().setData(true);
    }else{
      context.read<AuthProvider>().setData(false);
    }

  }

  void _updateButtonColor(){
    if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
      _isFullField = false;
      context.read<AuthProvider>().fullFieldLogin(false);
    }else{
      if(!_isFullField){
        _isFullField = true;
        context.read<AuthProvider>().fullFieldLogin(true);
      }
    }
  }

  void _submit() async{
    final form = _formKey.currentState!;
    if(form.validate()){
      form.save();
      form.validate();
      await context.read<AuthProvider>().login(_emailController.text, _passwordController.text);
      // if(context.watch<AuthProvider>().loginStatus == ModuleStatus.success){
      //   print("ok");
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ExampleView()),
      //         (Route<dynamic> route) => false,);
      // }

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
                Image.asset(Assets.images.authPNG),
                SizedBox(height: 16.h,),
                Text(
                  "Đăng nhập ngay!",
                  style: AppTextStyles.of(context).regular32.copyWith(
                      color: AppColors.of(context).neutralColor12
                  ),
                )
              ],
            )
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: AppTextStyles.of(context).light16.copyWith(
                        color: AppColors.of(context).neutralColor11
                      ),
                    ),
                    style: AppTextStyles.of(context).light20.copyWith(
                        color: AppColors.of(context).neutralColor12
                    ),
                    validator: (value) => !value!.contains('@') ? 'Không phải email':null,
                    onSaved: (newValue) => _emailController.text = newValue??"",
                    onChanged: (value) {
                      _updateButtonColor();
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Mật khẩu',
                      hintStyle: AppTextStyles.of(context).light16.copyWith(
                        color: AppColors.of(context).neutralColor11
                      ),
                      errorStyle: TextStyle(
                        color: context.watch<AuthProvider>().loginStatus
                            == ModuleStatus.success? Colors.green: AppColors.of(context).primaryColor10,
                      ),
                      errorText: context.watch<AuthProvider>().loginSuccess,
                      errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 1,
                                color: context.watch<AuthProvider>().loginStatus
                                    == ModuleStatus.success?AppColors.of(context)
                                    .neutralColor9:AppColors.of(context).primaryColor10)
                        ),
                      suffixIconColor: AppColors.of(context).neutralColor9,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscureText?Icons.visibility_off:Icons.visibility
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    ),
                    style: AppTextStyles.of(context).light20.copyWith(
                        color: AppColors.of(context).neutralColor12
                    ),
                    controller: _passwordController,
                    validator: (value) => value!.length < 2 ?'Mật khẩu phải nhiều hơn 2 ký tự':null,
                    onSaved: (newValue) => _passwordController.text = newValue??"",
                    onChanged: (value) {
                      _updateButtonColor();
                    },
                    obscureText: _obscureText,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 32.w, top: 32.h, right: 32.w),
            child: context.watch<AuthProvider>().isFullFieldLogin
              ?ScaleOnTapWidget(
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
            )
              :Container(
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
                "Đăng nhập",
                textAlign: TextAlign.center,
                style: AppTextStyles.of(context).regular32.copyWith(
                    color: AppColors.of(context).neutralColor11
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}
