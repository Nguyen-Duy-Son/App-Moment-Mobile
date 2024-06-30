import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopupMenuSelect extends StatefulWidget {
  const PopupMenuSelect({super.key, required this.options});
  final List<Map<String, dynamic>> options;

  @override
  State<PopupMenuSelect> createState() => _PopupMenuSelectState();
}

class _PopupMenuSelectState extends State<PopupMenuSelect> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.options.map((selectedOption) {
        return Column(
          children: [
            ListTile(
              title: Text(
                selectedOption['menu'] ?? "",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14.0),
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                Navigator.pop(context, selectedOption);
              },
            ),
            if (widget.options.indexOf(selectedOption) < widget.options.length - 1)
              Divider(
                color: Colors.grey,
                height: ScreenUtil().setHeight(1.0),
              ),
          ],
        );
      }).toList(),
    );
  }
}
