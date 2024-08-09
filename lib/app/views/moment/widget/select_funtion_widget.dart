import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hit_moments/app/providers/list_moment_provider.dart';
import 'package:hit_moments/app/views/moment/widget/popover_select_function.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../custom/widgets/icon_on_tap_scale.dart';

class SelectFunctionWidget extends StatefulWidget {
  const SelectFunctionWidget({super.key, required this.idUser, required this.urlImage});
  final String idUser;
  final String urlImage;
  @override
  State<SelectFunctionWidget> createState() => _SelectFunctionWidgetState();
}

class _SelectFunctionWidgetState extends State<SelectFunctionWidget> {
  var random = Random();
  Future<void> _saveImage(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;

    try {
      // Download image
      final http.Response response = await http.get(
          Uri.parse(widget.urlImage));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/SaveImage${random.nextInt(100)}.png';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Lưu ảnh thành công';
      }
    } catch (e) {
      message = e.toString();
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style:  TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFe91e63),
      ));
    }

    if (message != null) {

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

    }
  }
  @override
  Widget build(BuildContext context) {
    return IconOnTapScale(
      icon1Path: Assets.icons.burgerSVG,
      icon2Path: Assets.icons.closeSVG,
      icon2Color: AppColors.of(context).primaryColor9,
      padding: 3.w,
      borderColor: AppColors.of(context).primaryColor10,
      backGroundColor: AppColors.of(context).neutralColor1,
      icon1Color: AppColors.of(context).neutralColor9,
      iconHeight: 28.w, iconWidth: 28.w,
      onPress: () {
        showPopover(
          context: context,

          bodyBuilder: (context) =>
              PopoverSelectFunction(options: const [
                {'menu': 'Tải xuống'},
                {'menu': 'Xoá bài đăng'},
                {'menu': 'Ẩn bài đăng'},
                {'menu': 'Báo cáo'}],
                opTap: (func) {
                  switch(func){
                    case 'Tải xuống':
                      _saveImage(context);
                      break;
                    case 'Xoá bài đăng':
                      //context.read<MomentProvider>().deleteMoment(widget., description);
                      break;
                    case 'Ẩn bài đăng':
                      //context.read<ListMomentProvider>().saveImage(widget.urlImage);
                      break;
                    case 'Báo cáo':
                      //context.read<ListMomentProvider>().saveImage(widget.urlImage);
                      break;
                  }
                },
                userIDOfMoment: widget.idUser,
              ),
          onPop: () => print("Đã ấn"),
          direction: PopoverDirection.bottom,
          width: 150.w
        );
      },
    );
  }
}
