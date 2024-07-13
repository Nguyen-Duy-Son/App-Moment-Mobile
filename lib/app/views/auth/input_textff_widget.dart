import 'package:flutter/material.dart';

import '../../core/extensions/theme_extensions.dart';


class InputTextffWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final BuildContext context;
  final String? Function(String?) validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? errorText;
  final TextStyle? errorStyle;
  final UnderlineInputBorder? errorBorder;

  InputTextffWidget({
    required this.controller,
    required this.hintText,
    required this.context,
    required this.validator,
    this.onChanged,
    this.onSaved,
    this.obscureText = false,
    this.suffixIcon,
    this.errorText,
    this.errorStyle,
    this.errorBorder,
  });

  @override
  _InputTextffWidget createState() => _InputTextffWidget();
}

class _InputTextffWidget extends State<InputTextffWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.of(widget.context).light16.copyWith(
          color: AppColors.of(widget.context).neutralColor11,
        ),
        errorText: widget.errorText,
        errorStyle: widget.errorStyle,
        errorBorder: widget.errorBorder,
        suffixIcon: widget.suffixIcon,
        suffixIconColor: AppColors.of(widget.context).neutralColor9,
      ),
      style: AppTextStyles.of(widget.context).light20.copyWith(
        color: AppColors.of(widget.context).neutralColor12,
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
    );
  }
}