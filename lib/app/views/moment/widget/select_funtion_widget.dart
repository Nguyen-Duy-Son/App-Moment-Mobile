import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:hit_moments/app/models/moment_model.dart';
import 'package:hit_moments/app/providers/list_moment_provider.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:hit_moments/app/views/moment/widget/popover_select_function.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../custom/widgets/icon_on_tap_scale.dart';
import '../../../l10n/l10n.dart';

class SelectFunctionWidget extends StatefulWidget {
  const SelectFunctionWidget({super.key, required this.momentModel});
  final MomentModel momentModel;
  @override
  State<SelectFunctionWidget> createState() => _SelectFunctionWidgetState();
}

class _SelectFunctionWidgetState extends State<SelectFunctionWidget> {
  TextEditingController controller = TextEditingController();
  var random = Random();
  Future<void> _saveImage(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;
    try {
      final http.Response response = await http.get(
          Uri.parse(widget.momentModel.image??""));
      final dir = await getTemporaryDirectory();
      var filename = '${dir.path}/SaveImage${random.nextInt(100)}.png';
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);
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
          style:  const TextStyle(
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

  Future<void> _deleteMoment(String momentID) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.of(context).neutralColor1,
          title: Text(
            "Bạn có chắc chắn muốn xoá khoảnh khắc đẹp này?",
            textAlign: TextAlign.center,
            style: AppTextStyles.of(context).regular24.copyWith(
              color: AppColors.of(context).neutralColor12,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Assets.images.authPNG, height: 50),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ScaleOnTapWidget(
                        onTap: (isSelect) async {
                          Navigator.pop(context);
                          final momentProvider = context.read<MomentProvider>();
                          final listMomentProvider = context.read<ListMomentProvider>();

                          await momentProvider.deleteMoment(momentID);

                          if (momentProvider.deleteMomentStatus == ModuleStatus.success) {
                            listMomentProvider.deleteMomentLocal(widget.momentModel.momentID??"");
                            Fluttertoast.showToast(
                              msg: "Đã xoá thành công!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.w),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor1,
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                              width: 1,
                              color: AppColors.of(context).primaryColor9,
                            ),
                          ),
                          child: Text(
                            "Có",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.of(context).light24.copyWith(
                              color: AppColors.of(context).primaryColor9,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Space between buttons
                    Expanded(
                      child: ScaleOnTapWidget(
                        onTap: (isSelect) {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.w),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).primaryColor10,
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Text(
                            "Không",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.of(context).light24.copyWith(
                              color: AppColors.of(context).neutralColor1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> _reportMoment() async {
    controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.of(context).neutralColor1,
          title: Text(
            "Bạn có chắc chắn muốn báo cáo khoảnh khắc này?",
            textAlign: TextAlign.center,
            style: AppTextStyles.of(context).regular24.copyWith(
              color: AppColors.of(context).neutralColor12,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Assets.images.authPNG, height: 50),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Lý do bạn muốn báo cáo",
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ScaleOnTapWidget(
                        onTap: (isSelect) async {
                          if(controller.text.isNotEmpty){
                            Navigator.pop(context);
                            final momentProvider = context.read<MomentProvider>();
                            await momentProvider
                                .createReport(widget.momentModel.momentID??"",
                                controller.text, "Đơn báo cáo đã tổn tại");

                            if (momentProvider.createReportStatus == ModuleStatus.success) {
                              Fluttertoast.showToast(
                                msg: "Đã báo cáo thành công!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }else{
                              Fluttertoast.showToast(
                                msg: momentProvider.createReportResult,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.redAccent,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          }else{
                            Fluttertoast.showToast(
                              msg: "Không được để trống lý do!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.w),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor1,
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                              width: 1,
                              color: AppColors.of(context).primaryColor9,
                            ),
                          ),
                          child: Text(
                            "Có",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.of(context).light24.copyWith(
                              color: AppColors.of(context).primaryColor9,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Space between buttons
                    Expanded(
                      child: ScaleOnTapWidget(
                        onTap: (isSelect) {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.w),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).primaryColor10,
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Text(
                            "Không",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.of(context).light24.copyWith(
                              color: AppColors.of(context).neutralColor1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return IconOnTapScale(

      icon1Path: Assets.icons.burgerSVG,
      backGroundColor: AppColors.of(context).neutralColor1,
      icon1Color: AppColors.of(context).neutralColor9,
      padding: 3.w,
      borderColor: AppColors.of(context).primaryColor10,
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
                  opTap: (func) async{
                    switch(func){
                      case 'Tải xuống':
                        _saveImage(context);
                        break;
                      case 'Xoá bài đăng':
                        await Future.delayed(const Duration(milliseconds: 100));
                        _deleteMoment(widget.momentModel.momentID??"");
                        break;
                      case 'Ẩn bài đăng':
                        break;
                      case 'Báo cáo':
                        await Future.delayed(const Duration(milliseconds: 100));
                        _reportMoment();
                        break;
                    }
                  },
                  userIDOfMoment: widget.momentModel.userID??"",
                ),
            onPop: () => print("Đã ấn"),
            direction: PopoverDirection.bottom,
            width: 150.w
        );
      },
    );
  }
}