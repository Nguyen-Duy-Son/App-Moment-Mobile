// import 'dart:async';
// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hit_moments/app/core/config/enum.dart';
// import 'package:hit_moments/app/core/constants/assets.dart';
// import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
// import 'package:hit_moments/app/custom/widgets/app_bar_animation.dart';
// import 'package:hit_moments/app/datasource/local/storage.dart';
// import 'package:hit_moments/app/providers/auth_provider.dart';
// import 'package:hit_moments/app/providers/list_moment_provider.dart';
// import 'package:hit_moments/app/routes/app_routes.dart';
// import 'package:image/image.dart' as img;
// import 'package:provider/provider.dart';
// import 'package:skeletonizer/skeletonizer.dart';
//
// import '../../../providers/music_provider.dart';
// import '../../../providers/user_provider.dart';
// import '../service/camera_service.dart';
// import 'auto_switch_image_widget.dart';
// import 'display_pictures_screen.dart';
//
// // A screen that allows users to take a picture using a given camera.
// class TakePictureScreen extends StatefulWidget {
//   const TakePictureScreen({super.key, required this.pageParentController});
//
//   final PageController pageParentController;
//
//   @override
//   State<TakePictureScreen> createState() => _TakePictureScreenState();
// }
//
// class _TakePictureScreenState extends State<TakePictureScreen> {
//   late List<CameraDescription> cameras;
//   late CameraController cameraController;
//   int direction = 0;
//   FlashMode _flashMode = FlashMode.off;
//   double zoomLevel = 1.0; // Zoom level from 1x to 5x
//   bool isCameraReady = false;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async{
//       if (!isCameraReady) {
//         // Chỉ khởi tạo camera nếu chưa sẵn sàng
//         startCamera(direction);
//       }
//       context.read<AuthProvider>().updateAvatar(getAvatarUser());
//       context.read<ListMomentProvider>().getListImagesMoment();
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!isCameraReady) {
//       startCamera(direction);
//     }
//   }
//
// // Add this method to toggle flash
//   void toggleFlash() {
//     setState(() {
//       _flashMode =
//           _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
//     });
//     cameraController.setFlashMode(_flashMode);
//   }
//
//   void turnOffFlash() {
//     setState(() {
//       _flashMode = FlashMode.off;
//     });
//     cameraController.setFlashMode(_flashMode);
//   }
//
//   Future<void> startCamera(int direction) async {
//     try {
//       cameras = await availableCameras();
//     } catch (e) {
//       return;
//     }
//
//     if (cameras.isEmpty) {
//       return;
//     }
//
//     cameraController = CameraController(
//       cameras[direction],
//       ResolutionPreset.max,
//       enableAudio: false,
//     );
//
//     cameraController.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {
//         isCameraReady = true;
//       });
//     }).catchError((e) {});
//   }
//
//   Future<File> cropImageToAspectRatio(File imageFile) async {
//     final image = img.decodeImage(await imageFile.readAsBytes());
//     final width = image?.width;
//     final height = image?.height;
//
//     // Tính toán kích thước mới để cắt theo tỷ lệ 3:4
//     int? newWidth = width;
//     int newHeight = (width! * 4) ~/ 3;
//
//     if (newHeight > height!) {
//       newHeight = height;
//       newWidth = (height * 3) ~/ 4;
//     }
//
//     final croppedImage = img.copyCrop(
//       image!,
//       x: (width - newWidth!) ~/ 2,
//       y: (height - newHeight) ~/ 2,
//       width: newWidth,
//       height: newHeight,
//     );
//
//     // Lưu ảnh đã cắt ra file mới
//     final newPath =
//         '${imageFile.path.substring(0, imageFile.path.length - 4)}_cropped.jpg';
//     final croppedFile = File(newPath);
//     await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));
//
//     return croppedFile;
//   }
//
//   // Change Zoom Level
//   void toggleZoom() {
//     setState(() {
//       zoomLevel =
//           zoomLevel >= 3.0 ? 1.0 : zoomLevel + 1.0; // Cycle zoom from 1x to 5x
//     });
//     cameraController.setZoomLevel(zoomLevel);
//   }
//
//   @override
//   void deactivate() {
//     // Dừng camera khi widget không còn visible
//     cameraController.stopImageStream();
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     // Dừng camera preview và giải phóng tài nguyên
//     cameraController.stopImageStream(); // Dừng camera stream nếu đang chạy
//     cameraController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<ListMomentProvider>();
//     if (!isCameraReady || !cameraController.value.isInitialized) {
//       return const Center(child: AppPageWidget());
//     }
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.of(context).primaryColor1,
//         centerTitle: true,
//         title: Container(
//           margin: EdgeInsets.only(top: 4.w),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               GestureDetector(
//                 onTap: () async {
//                   await cameraController.pausePreview(); // Dừng camera
//                   Navigator.pushNamed(context, AppRoutes.MY_PROFILE)
//                       .then((_) async {
//                     // Tiếp tục camera khi quay lại màn hình
//                     await cameraController.resumePreview();
//                   });
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       border: Border.all(
//                           color: AppColors.of(context).neutralColor7,
//                           width: 4.w)),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: Image.network(
//                       context.watch<AuthProvider>().avatar!,
//                       width: 28.w,
//                       height: 28.w,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) {
//                           return child;
//                         }
//                         return Center(
//                           child: Skeletonizer(
//                             child: Container(
//                               width: 28.w,
//                               height: 28.w,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return SvgPicture.asset(
//                           Assets.icons.userSVG,
//                           width: 28.w,
//                           height: 28.w,
//                           color: AppColors.of(context).neutralColor7,
//                         );
//                       },
//
//
//                     ),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   await cameraController.pausePreview(); // Dừng camera
//                   Navigator.pushNamed(context, AppRoutes.LIST_MY_FRIEND)
//                       .then((_) async {
//                     // Tiếp tục camera khi quay lại màn hình
//                     await cameraController.resumePreview();
//                   });
//                 },
//                 child: Container(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       color: AppColors.of(context).neutralColor7),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       SvgPicture.asset(
//                         Assets.icons.usersSVG,
//                         height: 24.w,
//                         width: 24.w,
//                         color: AppColors.of(context).neutralColor11,
//                       ),
//                       Text(
//                         AppLocalizations.of(context)!.addfriend,
//                         style: AppTextStyles.of(context).regular24.copyWith(
//                               color: AppColors.of(context).neutralColor11,
//                             ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(10.w),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                   color: AppColors.of(context).neutralColor6,
//                 ),
//                 child: GestureDetector(
//                   child: SvgPicture.asset(
//                     Assets.icons.message,
//                     width: 20.w,
//                     height: 20.w,
//                     // color: AppColors.of(context).neutralColor6,
//                   ),
//                   // onTap: () =>
//                   //     Navigator.pushNamed(context, AppRoutes.MY_CONVERSATION),
//                   onTap: () async {
//                     await cameraController.pausePreview(); // Dừng camera
//                     Navigator.pushNamed(context, AppRoutes.MY_CONVERSATION)
//                         .then((_) async {
//                       // Tiếp tục camera khi quay lại màn hình
//                       await cameraController.resumePreview();
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         toolbarHeight: 52.w, // Set the height of the AppBar here
//       ),
//       body: Container(
//         margin: EdgeInsets.only(top: 80.h, left: 4.w, right: 4.w, bottom: 12.w),
//         alignment: Alignment.center,
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Positioned(
//                   child: SizedBox(
//                     height: 1.sw,
//                     width: 1.sw,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(50.w),
//                       child: FittedBox(
//                         fit: BoxFit.cover,
//                         child: SizedBox(
//                           width: cameraController.value.previewSize!.height,
//                           height: cameraController.value.previewSize!.width,
//                           child: CameraPreview(cameraController),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   right: 10.w,
//                   top: 20.h,
//                   child: InkWell(
//                     onTap: toggleZoom,
//                     child: Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
//                       decoration: BoxDecoration(
//                         color: AppColors.of(context).neutralColor8,
//                         borderRadius: BorderRadius.circular(50.w),
//                       ),
//                       child: Text(
//                         "${zoomLevel.toStringAsFixed(0)}x",
//                         style: AppTextStyles.of(context).regular12.copyWith(
//                               color: AppColors.of(context).neutralColor1,
//                             ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: 10.w,
//                   top: 20.h,
//                   child: Container(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       color: AppColors.of(context).neutralColor8,
//                     ),
//                     child: InkWell(
//                       onTap: toggleFlash,
//                       child: SvgPicture.asset(
//                         Assets.icons.lightning,
//                         color: _flashMode == FlashMode.torch
//                             ? AppColors.of(context)
//                                 .primaryColor9 // Flash on color
//                             : AppColors.of(context)
//                                 .neutralColor1, // Fla// sh off color
//                         width: 20.w,
//                         height: 20.h,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 40.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   width: 67.w,
//                   height: 56.w,
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(50)),
//                   child: IconButton(
//                     icon: SvgPicture.asset(
//                       'assets/icons/ic_library.svg',
//                       width: 67.w,
//                       height: 56.w,
//                       color: AppColors.of(context).neutralColor12,
//                     ),
//                     onPressed: () {},
//                   ),
//                 ),
//                 OutlinedButton(
//                   onPressed: () async {
//                     final image = await cameraController.takePicture();
//                     //final croppedImage = await cropImageToAspectRatio(File(image.path));
//                     turnOffFlash();
//                     if (!context.mounted) return;
//                     await Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => DisplayPictureScreen(
//                               image: image,
//                               //imagePath: croppedImage.path,
//                               users: context.watch<UserProvider>().friendList,
//                             )));
//                   },
//                   style: OutlinedButton.styleFrom(
//                       fixedSize: const Size(65, 65),
//                       shape: const CircleBorder(),
//                       side: BorderSide(
//                           color: AppColors.of(context).primaryColor10,
//                           width: 4.w),
//                       padding: const EdgeInsets.all(6)),
//                   child: Container(
//                     padding: const EdgeInsets.all(30),
//                     decoration: BoxDecoration(
//                         color: AppColors.of(context).neutralColor8,
//                         borderRadius: BorderRadius.circular(50)),
//                   ),
//                 ),
//                 IconButton(
//                   icon: SvgPicture.asset(
//                     Assets.icons.swap,
//                     width: 67.w,
//                     height: 56.w,
//                     color: AppColors.of(context).neutralColor12,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       direction = direction == 0 ? 1 : 0;
//                       startCamera(direction);
//                     });
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 30.w,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 provider.getListImageMoment == ModuleStatus.success &&
//                     provider.listImageMoment.isNotEmpty
//                     ? AutoSwitchImageRow(images: provider.listImageMoment ?? [])
//                     : provider.getListImageMoment == ModuleStatus.loading
//                     ? SvgPicture.asset(
//                   'assets/icons/ic_library.svg',
//                   width: 30.w,
//                   height: 30.w,
//                   color: AppColors.of(context).neutralColor12,
//                 )
//                     : SvgPicture.asset(
//                   'assets/icons/ic_library.svg',
//                   width: 30.w,
//                   height: 30.w,
//                   color: AppColors.of(context).neutralColor12,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10.w,
//             ),
//             GestureDetector(
//               onTap: () {
//                 widget.pageParentController.nextPage(
//                     duration: const Duration(milliseconds: 200),
//                     curve: Curves.easeInOut);
//               },
//               child: SvgPicture.asset(
//                 Assets.icons.downSVG,
//                 width: 16.w,
//                 height: 16.w,
//                 color: AppColors.of(context).neutralColor9,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/providers/auth_provider.dart';
import 'package:hit_moments/app/providers/list_moment_provider.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:image/image.dart' as img; //
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../providers/user_provider.dart';
import 'auto_switch_image_widget.dart';
import 'display_pictures_screen.dart';
import 'display_video_screen.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.pageParentController});

  final PageController pageParentController;

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool isCameraReady = false;
  int direction = 0;
  FlashMode _flashMode = FlashMode.off;
  double zoomLevel = 1.0; // Zoom level from 1x to 5x
  List<String?> listImageMoment = [];
  List<CameraDescription>? _cameras;
  bool isRecording = false;
  bool isPaused = false;
  int recordingDuration = 0; // Thời gian quay (giây)
  Timer? recordingTimer;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     if (!isCameraReady) {
  //       // Chỉ khởi tạo camera nếu chưa sẵn sàng
  //       startCamera(direction);
  //     }
  //     context.read<AuthProvider>().updateAvatar(getAvatarUser());
  //     await context.read<ListMomentProvider>().getListImagesMoment();
  //     if (context.watch<ListMomentProvider>().getListImageMoment ==
  //         ModuleStatus.success) {
  //       setState(() {
  //         listImageMoment = context.watch<ListMomentProvider>().listImageMoment;
  //       });
  //     }
  //   });
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!isCameraReady) {
        // Only initialize the camera if not ready
        startCamera(direction);
      }

      // Use listen: false to prevent listening outside the widget tree
      final authProvider = context.read<AuthProvider>();
      final listMomentProvider = context.read<ListMomentProvider>();

      authProvider.updateAvatar(getAvatarUser());
      await listMomentProvider.getListImagesMoment();

      if (listMomentProvider.getListImageMoment == ModuleStatus.success) {
        setState(() {
          listImageMoment = listMomentProvider.listImageMoment;
        });
      }
    });
  }

// Add this method to toggle flash
  void toggleFlash() {
    setState(() {
      _flashMode =
          _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    });
    cameraController.setFlashMode(_flashMode);
  }

  void turnOffFlash() {
    setState(() {
      _flashMode = FlashMode.off;
    });
    cameraController.setFlashMode(_flashMode);
  }

  Future<void> startCamera(int direction) async {
    try {
      // Lấy danh sách camera
      cameras = await availableCameras();

      if (cameras.isEmpty) {
        print("No cameras available");
        return;
      }

      // Khởi tạo controller
      cameraController = CameraController(
        cameras[direction],
        ResolutionPreset.high,
        enableAudio: true,
      );

      // Initialize camera
      await cameraController.initialize();

      if (!mounted) return;

      // Cập nhật state khi camera đã sẵn sàng
      setState(() {
        isCameraReady = true;
      });
    } catch (e) {
      print("Error starting camera: $e");
      // Có thể thêm xử lý lỗi ở đây
      setState(() {
        isCameraReady = false;
      });
    }
  }

  // Future<void> startCamera(int direction) async {
  //   try {
  //     cameras = await availableCameras();
  //   } catch (e) {
  //     return;
  //   }
  //
  //   if (cameras.isEmpty) {
  //     return;
  //   }
  //
  //   cameraController = CameraController(
  //     cameras[direction],
  //     ResolutionPreset.high,
  //     enableAudio: true,
  //   );
  //
  //   cameraController.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {
  //       isCameraReady = true;
  //     });
  //   }).catchError((e) {});
  // }

  void toggleZoom() {
    setState(() {
      zoomLevel =
          zoomLevel >= 3.0 ? 1.0 : zoomLevel + 1.0; // Cycle zoom from 1x to 5x
    });
    cameraController.setZoomLevel(zoomLevel);
  }

  @override
  void deactivate() {
    // Dừng camera khi widget không còn visible
    cameraController.stopImageStream();
    super.deactivate();
  }

  @override
  void dispose() {
    // Dừng camera preview và giải phóng tài nguyên
    cameraController.stopImageStream(); // Dừng camera stream nếu đang chạy
    cameraController.dispose();
    super.dispose();
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (isCameraReady) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.of(context).primaryColor1,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Container(
            margin: EdgeInsets.only(top: 4.w),
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await cameraController.pausePreview(); // Dừng camera
                      Navigator.pushNamed(context, AppRoutes.MY_PROFILE)
                          .then((_) async {
                        // Tiếp tục camera khi quay lại màn hình
                        await cameraController.resumePreview();
                      });
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
                          context.watch<AuthProvider>().avatar ?? "",
                          width: 28.w,
                          height: 28.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return SvgPicture.asset(
                              Assets.icons.avatar,
                              width: 28.w,
                              height: 28.w,
                              color: AppColors.of(context).neutralColor7,
                            );
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: Skeletonizer(
                                child: Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await cameraController.pausePreview(); // Dừng camera
                      Navigator.pushNamed(context, AppRoutes.LIST_MY_FRIEND)
                          .then((_) async {
                        // Tiếp tục camera khi quay lại màn hình
                        await cameraController.resumePreview();
                      });
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
                      // onTap: () =>
                      //     Navigator.pushNamed(context, AppRoutes.MY_CONVERSATION),
                      onTap: () async {
                        await cameraController.pausePreview(); // Dừng camera
                        Navigator.pushNamed(context, AppRoutes.MY_CONVERSATION)
                            .then((_) async {
                          // Tiếp tục camera khi quay lại màn hình
                          await cameraController.resumePreview();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          toolbarHeight: 52.w, // Set the height of the AppBar here
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: 40.h, left: 4.w, right: 4.w, bottom: 12.w),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      width: 100.w,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                      decoration: BoxDecoration(
                        color: isRecording
                            ? AppColors.of(context).neutralColor4
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        // Đảm bảo Row chỉ chiếm không gian vừa đủ nội dung
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Căn giữa chấm đỏ và text theo trục dọc
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 2.w),
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color:
                                  isRecording ? Colors.red : Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          // Khoảng cách giữa chấm đỏ và text
                          Text(
                            isRecording
                                ? formatDuration(recordingDuration)
                                : "",
                            style: AppTextStyles.of(context).regular24.copyWith(
                                  color: AppColors.of(context).neutralColor1,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (isCameraReady &&
                            cameraController.value.isInitialized)
                          SizedBox(
                            height: 1.sw,
                            width: 1.sw,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.w),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: cameraController
                                      .value.previewSize!.height,
                                  height:
                                      cameraController.value.previewSize!.width,
                                  child: CameraPreview(cameraController),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          right: 10.w,
                          top: 20.h,
                          child: InkWell(
                            onTap: toggleZoom,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.w),
                              decoration: BoxDecoration(
                                color: AppColors.of(context).neutralColor8,
                                borderRadius: BorderRadius.circular(50.w),
                              ),
                              child: Text(
                                "${zoomLevel.toStringAsFixed(0)}x",
                                style: AppTextStyles.of(context).regular12,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10.w,
                          top: 20.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.of(context).neutralColor8,
                            ),
                            child: InkWell(
                              onTap: toggleFlash,
                              child: SvgPicture.asset(
                                Assets.icons.lightning,
                                color: _flashMode == FlashMode.torch
                                    ? AppColors.of(context)
                                        .primaryColor9 // Flash on color
                                    : AppColors.of(context)
                                        .neutralColor12, // Fla// sh off color
                                width: 20.w,
                                height: 20.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 67.w,
                          height: 56.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                            icon: SvgPicture.asset(
                              !isRecording
                                  ? 'assets/icons/ic_library.svg'
                                  : (isPaused
                                      ? Assets.icons.playVideo
                                      : Assets.icons.pause),
                              width: 56.w,
                              height: 56.w,
                              color: AppColors.of(context).neutralColor12,
                            ),
                            onPressed: () async {
                              if (isPaused) {
                                await cameraController.resumeVideoRecording();
                                setState(() {
                                  isPaused = false;
                                  recordingTimer = Timer.periodic(
                                      const Duration(seconds: 1), (timer) {
                                    setState(() {
                                      recordingDuration++;
                                    });
                                  });
                                });
                              } else {
                                await cameraController.pauseVideoRecording();
                                setState(() {
                                  isPaused = true;
                                  recordingTimer
                                      ?.cancel(); // Dừng bộ đếm thời gian
                                });
                              }
                            },
                          ),
                        ),
                        GestureDetector(
                          onLongPressStart: (_) async {
                            if (!isRecording) {
                              setState(() {
                                isRecording = true;
                                recordingDuration = 0; // Đặt lại thời gian quay
                              });

                              // Bắt đầu bộ đếm thời gian
                              recordingTimer = Timer.periodic(
                                  const Duration(seconds: 1), (timer) {
                                setState(() {
                                  recordingDuration++;
                                });
                              });

                              await cameraController.startVideoRecording();
                            }
                          },
                          child: OutlinedButton(
                            onPressed: () async {
                              if (isRecording) {
                                final video =
                                    await cameraController.stopVideoRecording();
                                setState(() {
                                  isRecording = false;
                                  isPaused = false;
                                  recordingTimer
                                      ?.cancel(); // Hủy bỏ bộ đếm thời gian
                                });

                                // Chuyển sang màn hình phát lại video
                                if (!context.mounted) return;
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => DisplayVideoScreen(
                                    videoFile: video,
                                    widthVideo: cameraController
                                        .value.previewSize!.height,
                                    heightVideo: cameraController
                                        .value.previewSize!.width,
                                  ),
                                ));
                              } else {
                                final image =
                                    await cameraController.takePicture();
                                if (!context.mounted) return;
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => DisplayPictureScreen(
                                    image: image,
                                    users: context
                                        .watch<UserProvider>()
                                        .friendList,
                                  ),
                                ));
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              fixedSize: const Size(65, 65),
                              shape: const CircleBorder(),
                              side: BorderSide(
                                color: AppColors.of(context).primaryColor10,
                                width: 4.w,
                              ),
                              padding: const EdgeInsets.all(6),
                            ),
                            child: isRecording
                                ? SvgPicture.asset(Assets.icons.stop,
                                    width: 40.w,
                                    height: 40.w,
                                    color: Colors.red // Đổi màu khi đang quay
                                    )
                                : Container(
                                    padding: const EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      color: isRecording
                                          ? Colors.red // Đổi màu khi đang quay
                                          : AppColors.of(context).neutralColor8,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            width: 56.w,
                            height: 56.w,
                            padding: isRecording
                                ? EdgeInsets.all(10.w)
                                : EdgeInsets.zero,
                            child: SvgPicture.asset(
                              isRecording
                                  ? Assets.icons.remove
                                  : Assets.icons.swap,
                              color: AppColors.of(context).neutralColor12,
                            ),
                          ),
                          onPressed: () {
                            if (!isRecording) {
                              setState(() {
                                direction = direction == 0 ? 1 : 0;
                                startCamera(direction);
                              });
                            } else {
                              cameraController.stopVideoRecording();
                              setState(() {
                                isRecording = false;
                                isPaused = false;
                                recordingTimer
                                    ?.cancel(); // Dừng bộ đếm thời gian
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        context
                                    .watch<ListMomentProvider>()
                                    .getListImageMoment ==
                                ModuleStatus.success
                            ? AutoSwitchImageRow(
                                images: context
                                        .watch<ListMomentProvider>()
                                        .listImageMoment ??
                                    [])
                            // : provider.getListImageMoment == ModuleStatus.loading
                            : Center(
                                child: Skeletonizer(
                                  child: Container(
                                    // width: 35.w,
                                    // height: 35.w,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.pageParentController.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                      },
                      child: SvgPicture.asset(
                        Assets.icons.downSVG,
                        width: 16.w,
                        height: 16.w,
                        color: AppColors.of(context).neutralColor9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
