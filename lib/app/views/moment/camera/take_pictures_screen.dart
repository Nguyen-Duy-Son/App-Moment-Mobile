// app/views/moment/camera/take_pictures_screen.dart
// main.dart
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../providers/weather_provider.dart';
import 'display_pictures_screen.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.pageParentController});

  final PageController pageParentController;

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late List<CameraDescription> cameras;
  CameraController? cameraController;
  bool isCameraReady = false;
  int direction = 0;

  @override
  void initState() {
    super.initState();
    startCamera(direction);
    context.read<WeatherProvider>().getCurrentPosition();
  }

  Future<void> startCamera(int direction) async {
    try {
      cameras = await availableCameras();
    } catch (e) {
      print('Error: ${e.toString()}');
      return;
    }

    if (cameras == null || cameras.isEmpty) {
      print('No camera is available');
      return;
    }

    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.max,
      enableAudio: false,
    );

    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isCameraReady = true;
      });
    }).catchError((e) {
      print('Error: ${e.toString()}');
    });
  }

  Future<File> cropImageToAspectRatio(File imageFile) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    final width = image?.width;
    final height = image?.height;

    // Tính toán kích thước mới để cắt theo tỷ lệ 3:4
    int? newWidth = width;
    int newHeight = (width! * 4) ~/ 3;

    if (newHeight > height!) {
      newHeight = height;
      newWidth = (height * 3) ~/ 4;
    }

    final croppedImage = img.copyCrop(
      image!,
      x: (width - newWidth!) ~/ 2,
      y: (height - newHeight) ~/ 2,
      width: newWidth,
      height: newHeight,
    );

    // Lưu ảnh đã cắt ra file mới
    final newPath =
        '${imageFile.path.substring(0, imageFile.path.length - 4)}_cropped.jpg';
    final croppedFile = File(newPath);
    await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));

    return croppedFile;
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isCameraReady) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.of(context).primaryColor1,
            centerTitle: true,
            title: Container(
              margin: EdgeInsets.only(top: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.MY_PROFILE);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: AppColors.of(context).neutralColor7,
                              width: 4.w)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          getAvatarUser(),
                          width: 28.w,
                          height: 28.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.LIST_MY_FRIEND);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors.of(context).neutralColor7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset(
                            Assets.icons.usersSVG,
                            height: 24.w,
                            width: 24.w,
                            color: AppColors.of(context).neutralColor11,
                          ),
                          Text(
                            AppLocalizations.of(context)!.addfriend,
                            style: AppTextStyles.of(context).regular24.copyWith(
                                  color: AppColors.of(context).neutralColor11,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.of(context).neutralColor6,
                    ),
                    child: GestureDetector(
                      child: SvgPicture.asset(
                        Assets.icons.message,
                        width: 20.w,
                        height: 20.w,
                        // color: AppColors.of(context).neutralColor6,
                      ),
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.MY_CONVERSATION),
                    ),
                  ),
                ],
              ),
            ),
            toolbarHeight: 52.w, // Set the height of the AppBar here
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 1.sw - 4.w,
                  height: 1.sw - 4.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CameraPreview(cameraController!),
                  ),
                ),
                SizedBox(
                  height: 40.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: SvgPicture.asset(
                        Assets.icons.lightning,
                        width: 44.w,
                        height: 44.w,
                        color: AppColors.of(context).neutralColor12,
                      ),
                      onTap: () {},
                    ),
                    SizedBox(
                      width: 24.w,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        final XFile image =
                            await cameraController!.takePicture();
                        if (!context.mounted) return;
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayPictureScreen(
                              image: image,
                              users: context.watch<UserProvider>().friendList,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                          fixedSize: const Size(65, 65),
                          shape: const CircleBorder(),
                          side: BorderSide(
                              color: AppColors.of(context).primaryColor10,
                              width: 4.w),
                          padding: const EdgeInsets.all(6)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor8,
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                    SizedBox(
                      width: 18.w,
                    ),
                    GestureDetector(
                      child: SvgPicture.asset(
                        Assets.icons.swap,
                        width: 40.w,
                        height: 40.w,
                        color: AppColors.of(context).neutralColor9,
                      ),
                      onTap: () {
                        setState(() {
                          direction = direction == 0 ? 1 : 0;
                          startCamera(direction);
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 28.w,
                ),
                Container(
                  margin: EdgeInsets.only(right: 6.w),
                  child: GestureDetector(
                    onTap: () {
                      widget.pageParentController.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: SvgPicture.asset(
                      Assets.icons.downSVG,
                      width: 16.w,
                      height: 16.w,
                      color: AppColors.of(context).neutralColor9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // body: Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 4.w),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       SizedBox(
          //         width: 1.sw - 8.w,
          //         height: 1.sw - 8.w,
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(50),
          //           child: CameraPreview(cameraController!),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 40.w,
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           GestureDetector(
          //             child: SvgPicture.asset(
          //               Assets.icons.lightning,
          //               width: 44.w,
          //               height: 44.w,
          //               color: AppColors.of(context).neutralColor9,
          //             ),
          //             onTap: () {},
          //           ),
          //           // SizedBox(
          //           //   width: 28.w,
          //           // ),
          //           OutlinedButton(
          //             onPressed: () async {
          //               final XFile image =
          //                   await cameraController!.takePicture();
          //               if (!context.mounted) return;
          //               await Navigator.of(context).push(MaterialPageRoute(
          //                   builder: (context) => DisplayPictureScreen(
          //                         image: image,
          //                         users:
          //                             context.watch<UserProvider>().friendList,
          //                       ),),);
          //             },
          //             style: OutlinedButton.styleFrom(
          //                 fixedSize: const Size(65, 65),
          //                 shape: const CircleBorder(),
          //                 side: BorderSide(
          //                     color: AppColors.of(context).primaryColor10,
          //                     width: 4.w),
          //                 padding: const EdgeInsets.all(6)),
          //             child: Container(
          //               decoration: BoxDecoration(
          //                   color: AppColors.of(context).neutralColor8,
          //                   borderRadius: BorderRadius.circular(50)),
          //
          //             ),
          //           ),
          //           // SizedBox(
          //           //   width: 12.w,
          //           // ),
          //           GestureDetector(
          //             child: SvgPicture.asset(
          //               Assets.icons.swap,
          //               width: 44.w,
          //               height: 44.w,
          //               color: AppColors.of(context).neutralColor9,
          //             ),
          //             onTap: () {
          //               setState(() {
          //                 direction = direction == 0 ? 1 : 0;
          //                 startCamera(direction);
          //               });
          //             },
          //           ),
          //         ],
          //       ),
          //       SizedBox(
          //         height: 40.w,
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           widget.pageParentController.nextPage(
          //               duration: Duration(milliseconds: 200),
          //               curve: Curves.easeInOut);
          //         },
          //         child: SvgPicture.asset(
          //           Assets.icons.downSVG,
          //           width: 16.w,
          //           height: 16.w,
          //           color: AppColors.of(context).neutralColor9,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
