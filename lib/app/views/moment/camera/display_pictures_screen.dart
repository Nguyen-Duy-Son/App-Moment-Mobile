import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
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
import 'package:hit_moments/app/providers/weather_provider.dart';
import 'package:provider/provider.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final XFile image;
  final List<User> users;

  const DisplayPictureScreen(
      {super.key, required this.image, required this.users});

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
  bool checkWeather = false;
  String? weather;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListMomentProvider>().getListMoment();
    });
    if (context.read<WeatherProvider>().weatherStatus == ModuleStatus.initial) {
      context.read<WeatherProvider>().getCurrentPosition();
    }
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
        body: Container(
          margin: EdgeInsets.only(top: 30.w, left: 4.w, right: 4.w),
          child: Column(
            children: [
              Form(
                key: _globalKey,
                child: Stack(alignment: Alignment.topRight, children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(
                        aspectRatio: 3/4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(File(widget.image.path),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Consumer<WeatherProvider>(
                        builder: (context, weatherProvider, child) {
                          if (weatherProvider.weatherStatus !=
                              ModuleStatus.initial) {
                            weatherController.text =
                                "${weatherProvider.weather?.city}|${weatherProvider.weather?.tempC}|${weatherProvider.weather?.icon}";
                            return checkWeather?Positioned(
                              top: 16.w,
                              right: 0,
                              width: weatherProvider.weather?.icon == null
                                  ? MediaQuery.of(context).size.width / 3.5
                                  : MediaQuery.of(context).size.width / 2.7,
                              child: Row(
                                children: [
                                  weatherProvider.weather?.icon == null
                                      ? SvgPicture.asset(Assets.icons.sunSVG,
                                          height: 24.w, width: 24.w)
                                      : CachedNetworkImage(
                                          imageUrl:
                                              "https:${weatherProvider.weather?.icon}",
                                          fit: BoxFit.cover,
                                        ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.3)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.only(left: 8.w, right: 8.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            weatherProvider.weather?.city ?? "",
                                            maxLines: 1,
                                            style: AppTextStyles.of(context)
                                                .light14
                                                .copyWith(
                                              height: 1,
                                              overflow: TextOverflow.ellipsis,
                                              color: AppColors.of(context)
                                                  .neutralColor1,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 1.0,
                                                  color: AppColors.of(context)
                                                      .neutralColor12,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "${weatherProvider.weather?.tempC ?? 29}℃",
                                            style: AppTextStyles.of(context)
                                                .regular20
                                                .copyWith(
                                              height: 1,
                                              color: AppColors.of(context)
                                                  .neutralColor3,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 1.0,
                                                  color: AppColors.of(context)
                                                      .neutralColor12,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ):const SizedBox();
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      SingleChildScrollView(
                        reverse: true,
                        padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom / 2.3),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(60.w, 0, 60.w, 10.w),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor6,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(1, 1),
                                  color: Colors.black45)
                            ],
                          ),
                          child: TextFormField(
                            controller: feelingController,
                            style: const TextStyle(fontSize: 24),
                            maxLength: 30,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.feel,
                              hintStyle: AppTextStyles.of(context)
                                  .light24
                                  .copyWith(
                                      color:
                                          AppColors.of(context).neutralColor10),
                              contentPadding: EdgeInsets.only(
                                  left: 12.w, right: 12.w,top:4.w,bottom:4.w),
                              border: InputBorder.none,
                              counterText: "", // Add this line

                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              SizedBox(height: 50.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {

                        checkWeather = !checkWeather;
                      });
                    },
                    child: !checkWeather?SvgPicture.asset(Assets.icons.cloud1SVG):SvgPicture.asset(Assets.icons.cloud2SVG),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      createMoment();
                    },
                    style: OutlinedButton.styleFrom(
                        fixedSize: const Size(65, 65),
                        backgroundColor: AppColors.of(context).neutralColor6,
                        shape: const CircleBorder(),
                        side: BorderSide(
                            color: AppColors.of(context).primaryColor10,
                            width: 4),
                        padding: const EdgeInsets.fromLTRB(4, 6, 12, 2)),
                    child: SvgPicture.asset(
                      Assets.icons.sendSVG,
                      height: 60.w,
                      width: 60.w,
                      color: AppColors.of(context).neutralColor12,
                    ),
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
      ),
    );
  }

  Future<void> createMoment() async {
    final momentProvider = context.read<MomentProvider>();
    if(checkWeather==false){
      weather = "";
    }
    else{
      weather = weatherController.text;
    }
    print(weather);
    await momentProvider.createMoment(
        feelingController.text, weather, widget.image);
    if (momentProvider.createMomentStatus == ModuleStatus.success) {
      Fluttertoast.showToast(
        msg: "Thành công",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
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
