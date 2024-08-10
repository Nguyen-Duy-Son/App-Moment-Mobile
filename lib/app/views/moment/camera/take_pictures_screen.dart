// app/views/moment/camera/take_pictures_screen.dart
// main.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:hit_moments/app/views/moment/camera/display_pictures_screen.dart';
import 'package:hit_moments/app/views/suggested_friends/suggested_friends_view.dart';
import 'package:provider/provider.dart';

import '../../profile/personalPageWidget.dart';
// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});
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

    await cameraController!.initialize().then((value) {
      if(!mounted) {return;}
      setState(() {isCameraReady = true;}); //To refresh widget
    }).catchError((e) {print(e);});
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(isCameraReady) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row (
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColors.of(context).primaryColor6),
                    child: IconButton(icon: SvgPicture.asset(Assets.icons.user), onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => PersonalPageWidget()),
                      // );
                    },) 
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SuggestedFriendsView())
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.of(context).primaryColor6, ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
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
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColors.of(context).primaryColor6),
//                     child: IconButton(icon: SvgPicture.asset(Assets.icons.union), onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => const ListMyFriendView())
//                       );
//                     },) // TODO: Chuyển đến màn nhắn tin
                    child: IconButton(icon: SvgPicture.asset(Assets.icons.union), onPressed: ()=>Navigator.pushNamed(
                      context, AppRoutes.MY_CONVERSATION
                    ),) // TODO: Chuyển đến màn nhắn tin
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 3/4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CameraPreview(cameraController!),)
              ),
              const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 67.w,
                    height: 56.h,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: IconButton(icon: SvgPicture.asset(Assets.icons.lightning,), onPressed: () {},), // TODO: Bật đèn Flash
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final image = await cameraController!.takePicture();
                      if(!context.mounted) return;
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(imagePath: image.path, users: context.watch<UserProvider>().friendList,)
                        )
                      );
                    }, // TODO: Chụp ảnh và chuyển đến màn display pictures
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(65, 65),
                      shape: const CircleBorder(),
                      side: BorderSide(color: AppColors.of(context).primaryColor10, width: 4.w),
                      padding: const EdgeInsets.all(6)
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: AppColors.of(context).neutralColor8,
                        borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(Assets.icons.swap, width: 60.w, height: 60.h,),
                      onPressed: () {setState(() {
                        direction = direction == 0 ? 1 : 0;
                        startCamera(direction);
                      }); 
                    },
                  ), //TODO: Đảo camera trước sau
                ],
              ),
              // const SizedBox(height: 15,),
              IconButton(onPressed: () {}, icon: SvgPicture.asset(Assets.icons.downSVG, height: 10,), ),
            ],
          ),
        ),
      );
    } else {return const SizedBox();}
  }
}