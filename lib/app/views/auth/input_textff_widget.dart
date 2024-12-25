import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';

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
  final OutlineInputBorder? errorBorder;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;
  final String? labelText;
  final bool? isRequired;
  final bool? enabled;
  final bool? isReadOnly;
  final List<TextInputFormatter>? inputFormatters;
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
    this.enabledBorder,
    this.focusedBorder,
    this.labelText,
    this.isRequired = false,
    this.enabled = true,
    this.isReadOnly = false,
    this.inputFormatters,
  });

  @override
  _InputTextffWidget createState() => _InputTextffWidget();
}

class _InputTextffWidget extends State<InputTextffWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Row(
            children: [
              Text(
                widget.labelText!,
                style: AppTextStyles.of(widget.context).light20.copyWith(
                      color: AppColors.of(widget.context).neutralColor12,
                    ),
              ),
              if (widget.isRequired ?? true) ...[
                SizedBox(width: 4.w),
                Text(
                  "*",
                  style: AppTextStyles.of(widget.context).light20.copyWith(
                        color: Colors.red,
                      ),
                ),
              ],
            ],
          ),
        SizedBox(height: 8.w),
        TextFormField(
          readOnly: widget.isReadOnly ?? false,
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.of(widget.context).light16.copyWith(
                  color: AppColors.of(widget.context).neutralColor8,
                ),
            contentPadding: EdgeInsets.only(
                right: 10.w, top: 10.h, bottom: 10.h, left: 10.w),
            errorText: widget.errorText,
            errorStyle: widget.errorStyle,
            errorBorder: widget.errorBorder ??
                const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
            enabled: widget.enabled ?? true,
            enabledBorder: widget.enabledBorder ?? OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.of(widget.context).neutralColor12,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.w),
              borderSide: BorderSide(color: AppColors.of(context).neutralColor12),
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.of(context).neutralColor6), borderRadius: BorderRadius.circular(8.w)),
            focusedBorder: widget.focusedBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.of(widget.context).neutralColor12,
                  ),
                ),
            suffixIcon: widget.suffixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: widget.suffixIcon)
                : null,
            suffixIconColor: AppColors.of(widget.context).neutralColor9,
            suffixIconConstraints: BoxConstraints(
              maxHeight: 36.w,
              maxWidth: 36.w,
            ),
          ),
          style: AppTextStyles.of(widget.context).light20.copyWith(
                color: AppColors.of(widget.context).neutralColor12,
              ),
          validator: widget.validator,
          onSaved: widget.onSaved,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
          inputFormatters: widget.inputFormatters,
        ),
      ],
    );
  }
}
