import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/models/user_model.dart';
import 'package:hit_moments/app/providers/list_moment_provider.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:hit_moments/app/providers/weather_provider.dart';
import 'package:provider/provider.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final List<User> users;
  const DisplayPictureScreen({super.key, required this.imagePath, required this.users});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //Controller
  final TextEditingController feelingController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController weatherController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController createAtController = TextEditingController();
  final TextEditingController updateAtController = TextEditingController();
  final TextEditingController imgAvatarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ListMomentProvider>().getListMoment();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.sendto,
                style: AppTextStyles.of(context)
                    .regular32
                    .copyWith(color: AppColors.of(context).neutralColor12),
              ),
              const SizedBox(width: 35),
            ],
          ),
        ),
        body: Column(
          children: [
            Form(
              key: _globalKey,
              child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        AspectRatio(
                          aspectRatio: 3/4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(File(widget.imagePath), fit: BoxFit.fill),
                          ),
                        ),
                        Consumer<WeatherProvider>(
                          builder: (context, weatherProvider, child) {
                            if (weatherProvider.weatherStatus != ModuleStatus.initial) {
                              weatherController.text="${weatherProvider.weather?.city}|${weatherProvider.weather?.tempC}|${weatherProvider.weather?.icon}";
                              return Positioned(
                                top: 16.w,
                                right: 0,
                                width: weatherProvider.weather?.icon==null?MediaQuery.of(context).size.width/3.5:MediaQuery.of(context).size.width/2.7,
                                child: Row(
                                  children: [
                                    weatherProvider.weather?.icon==null?SvgPicture.asset(Assets.icons.sunSVG)
                                        :CachedNetworkImage(imageUrl: "https:${weatherProvider.weather?.icon}",
                                      fit: BoxFit.cover,),
                                    SizedBox(width: 8.w,),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                        padding: EdgeInsets.only(right: 16.w),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              weatherProvider.weather?.city??"",
                                              maxLines: 1,
                                              style: AppTextStyles.of(context).light14.copyWith(
                                                overflow: TextOverflow.ellipsis,
                                                color: AppColors.of(context).neutralColor1,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 1.0,
                                                    color: AppColors.of(context).neutralColor12,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text("${weatherProvider.weather?.tempC??29}℃",
                                              style: AppTextStyles.of(context).regular20.copyWith(
                                                color: AppColors.of(context).neutralColor3,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 1.0,
                                                    color: AppColors.of(context).neutralColor12,
                                                  ),
                                                ],
                                              ),)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        SingleChildScrollView(
                          reverse: true,
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom/2.3),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(50, 0, 50, 25),
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                            decoration: BoxDecoration(
                                color: AppColors.of(context).neutralColor6,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(1, 1),
                                      color: Colors.black45
                                  )
                                ]
                            ),
                            child: TextField(
                                controller: feelingController,
                                style: const TextStyle( fontSize: 24),
                                decoration: InputDecoration.collapsed(hintText: AppLocalizations.of(context)!.feel, hintStyle: AppTextStyles.of(context).light24.copyWith(color: AppColors.of(context).neutralColor10))
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    createMoment();
                  },
                  style: OutlinedButton.styleFrom(
                      fixedSize: const Size(65, 65),
                      backgroundColor: AppColors.of(context).neutralColor6,
                      shape: const CircleBorder(),
                      side: BorderSide(color: AppColors.of(context).primaryColor10, width: 4),
                      padding: const EdgeInsets.fromLTRB(4, 6, 12, 2)
                  ),
                  child: SvgPicture.asset(Assets.icons.sendSVG, height: 60.w, width: 60.w, color: AppColors.of(context).neutralColor12,),
                ),
                IconButton(
                  onPressed: () {
                    print('Đã ấn');

                  },
                  icon: SvgPicture.asset(Assets.icons.download2SVG),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createMoment()async{
    final momentProvider = context.read<MomentProvider>();
    await momentProvider.createMoment(
        'Đang thử lần đầu', weatherController.text, File(widget.imagePath));
    if(momentProvider.createMomentStatus == ModuleStatus.success){
      Fluttertoast.showToast(
        msg: "Thành công",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }else{
      Fluttertoast.showToast(
        msg: momentProvider.createMomentResult,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
