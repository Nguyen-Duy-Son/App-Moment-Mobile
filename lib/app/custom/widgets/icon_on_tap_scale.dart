import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconOnTapScale extends StatefulWidget {
  final String icon1Path;
  final String? icon2Path;
  final Color backGroundColor;
  final Color icon1Color;
  final Color? icon2Color;
  final double? padding;
  final double iconHeight;
  final double iconWidth;
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
          _isIcon1 = !_isIcon1;
        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1.0;
        });
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
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.backGroundColor,
            border: Border.all(
              color: widget.icon1Color,
              width: 1
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
