import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/theme_extensions.dart';

class ButtonSelectOption extends StatefulWidget {
  final String title;
  final Color colorBackGround;
  final Color color;
  final Function onTap;

  const ButtonSelectOption({
    super.key,
    required this.title,
    required this.colorBackGround,
    required this.color,
    required this.onTap,
  });

  @override
  _ButtonSelectOptionState createState() => _ButtonSelectOptionState();
}

class _ButtonSelectOptionState extends State<ButtonSelectOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: widget.colorBackGround,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: AppColors.of(context).primaryColor9,
            width: 2,
          ),
        ),
        child: Text(
          widget.title,
          style: AppTextStyles.of(context).light20.copyWith(
            color: widget.color,
          ),
        ),
      ),
    );
  }
}