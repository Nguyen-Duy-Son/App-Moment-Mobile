import 'package:flutter/material.dart';

class ScaleOnTapWidget extends StatefulWidget {
  const ScaleOnTapWidget({super.key, required this.child, required this.onTap,});
  final Widget child;
  final void Function(bool isSelect) onTap;


  @override
  State<ScaleOnTapWidget> createState() => _ScaleOnTapWidgetState();
}

class _ScaleOnTapWidgetState extends State<ScaleOnTapWidget> {
  double _scale = 1.0;
  bool _isSelect = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = 0.9;
          _isSelect = !_isSelect;
          widget.onTap(_isSelect);
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
        child: widget.child,
      )
    );
  }
}
