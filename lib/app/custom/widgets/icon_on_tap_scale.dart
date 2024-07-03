import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconOnTapScale extends StatefulWidget {
  final String icon1Path;  //icon mặc định ban đầu
  final String? icon2Path; //icon thay đổi khi ấn
  final Color backGroundColor;  //màu nền
  final Color icon1Color;  //màu icon mặc định
  final Color? icon2Color;  //màu của "icon thay đổi khi ấn"
  final double? padding;
  final double iconHeight;  //dài icon
  final double iconWidth;   // rộng icon
  final void Function() onPress;
  const IconOnTapScale({super.key,
    required this.icon1Path,
    required this.backGroundColor,
    required this.icon1Color,
    required this.iconHeight,
    required this.iconWidth,
    required this.onPress,
    this.icon2Path,
    this.padding,
    this.icon2Color,});
  @override
  _IconOnTapScale createState() => _IconOnTapScale();
}

class _IconOnTapScale extends State<IconOnTapScale> {
  double _scale = 1.0;
  bool _isIcon1 = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = 0.9;

        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1.0;
          _isIcon1 = !_isIcon1;
        });
        widget.onPress();
      },
      onTapCancel: () {
        setState(() {
          _scale = 1.0;

        });

      },
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.backGroundColor,
            border: Border.all(
              color: widget.icon1Color,
              width: 1.w
            )
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.padding??0),
            child: SvgPicture.asset(
              _isIcon1?widget.icon1Path:(widget.icon2Path??widget.icon1Path),
              color: _isIcon1?widget.icon1Color:(widget.icon2Color??widget.icon1Color),
              height: widget.padding==null?widget.iconHeight:widget.iconHeight*0.8,
              width: widget.padding==null?widget.iconWidth:widget.iconWidth*0.8,),
          ),
        ),
      ),
    );
  }
}
