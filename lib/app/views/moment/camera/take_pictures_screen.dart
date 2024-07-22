// app/views/moment/camera/take_pictures_screen.dart
// main.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/views/moment/camera/display_pictures_screen.dart';
// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  int direction = 0;

  @override
  void initState() {
    startCamera(direction);
    super.initState();
  }

  Future<void> startCamera(int direction) async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.max,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if(!mounted) {return;}
      setState(() {}); //To refresh widget
    }).catchError((e) {print(e);});
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(cameraController.value.isInitialized) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Row (
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColors.of(context).primaryColor6),
                    child: IconButton(icon: SvgPicture.asset(Assets.icons.user), onPressed: () {},) // TOTO: Chuyển đến màn trang cá nhân
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.of(context).primaryColor6, ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset(Assets.icons.adduser),
                          Text(AppLocalizations.of(context)!.addfriend,
                            style: AppTextStyles.of(context).regular32.copyWith(color: AppColors.of(context).neutralColor12,),
                          )
                        ],
                      )
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColors.of(context).primaryColor6),
                    child: IconButton(icon: SvgPicture.asset(Assets.icons.union), onPressed: () {},) // TODO: Chuyển đến màn nhắn tin
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 400.w,
                  height: 470.h,
                  child: CameraPreview(cameraController),)
              ),
              const SizedBox(height: 35,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 65.w,
                    height: 70.h,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: IconButton(icon: SvgPicture.asset(Assets.icons.lightning,), onPressed: () {},), // TODO: Bật đèn Flash
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final image = await cameraController.takePicture();
                      if(!context.mounted) return;
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(imagePath: image.path)
                        )
                      );
                    }, // TODO: Chụp ảnh và chuyển đến màn display pictures
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(70, 70),
                      shape: const CircleBorder(),
                      side: BorderSide(color: AppColors.of(context).primaryColor10, width: 4.w),
                      padding: const EdgeInsets.all(7)
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: AppColors.of(context).neutralColor8,
                        borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(Assets.icons.swap, width: 58.w, height: 58.h,),
                      onPressed: () {setState(() {
                        direction = direction == 0 ? 1 : 0;
                        startCamera(direction);
                      }); 
                    },
                  ), //TODO: Đảo camera trước sau
                ],
              ),
              // const SizedBox(height: 15,),
              IconButton(onPressed: () {}, icon: SvgPicture.asset(Assets.icons.downSVG, height: 15,), ),
            ],
          ),
        ),
      );
    } else {return const SizedBox();}
  }
}