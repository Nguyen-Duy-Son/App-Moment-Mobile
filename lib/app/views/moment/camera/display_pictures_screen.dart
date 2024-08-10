// app/views/moment/camera/display_pictures_screen.dart
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/models/user_model.dart';
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
  // ignore: no_logic_in_create_state
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
    context.read<WeatherProvider>().getCurrentPosition();
    context.read<MomentProvider>().getListMoment();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> _showWeather = ValueNotifier(false);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.sendto,
                style: AppTextStyles.of(context).regular32.copyWith(
                color: AppColors.of(context).neutralColor12,),
              ),
              const SizedBox(width: 35,)
            ],
          )
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
                          ), //TODO: Cảm nghĩ...
                        ), 
                      ),
                    ],
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _showWeather, 
                    builder: (context, value, child) {
                      return value ? Positioned(
                          top: 30.w,
                          right: 0,
                          width: 150.w,
                          height: 54.h,
                          child: Consumer<WeatherProvider>(
                            builder: (context, weatherProvider, child) {
                              if (weatherProvider.weatherStatus != ModuleStatus.initial) {
                                return Row(
                                  children: [
                                    CachedNetworkImage(imageUrl: "https:${weatherProvider.weather?.icon}"),
                                    SizedBox(width: 8.w,),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight
                                          )
                                        ),
                                        padding: EdgeInsets.only(right: 16.w),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("${weatherProvider.weather?.city}", style: AppTextStyles.of(context).light16.copyWith(color: AppColors.of(context).neutralColor3, fontSize: 16)),
                                            Text("${weatherProvider.weather?.tempC}℃", style: AppTextStyles.of(context).regular20.copyWith(color: AppColors.of(context).neutralColor3, fontSize: 20)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10)
                                  ],
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }
                          )
                      ): const SizedBox();
                    }
                  ),
                ]
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _showWeather,
                  builder: (context, value, child) {
                    return IconButton(
                      onPressed: () {
                        _showWeather.value = !_showWeather.value;
                      },
                      icon: SvgPicture.asset(value ? Assets.icons.cloud2SVG : Assets.icons.cloud1SVG)
                    );
                  },
                ), //TODO: Thêm thời tiết
                OutlinedButton(
                    onPressed: () async {},
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(65, 65),
                      backgroundColor: AppColors.of(context).neutralColor6,
                      shape: const CircleBorder(),
                      side: BorderSide(color: AppColors.of(context).primaryColor10, width: 4),
                      padding: const EdgeInsets.fromLTRB(4, 6, 12, 2)
                    ),
                    child: SvgPicture.asset(Assets.icons.sendSVG, height: 60.w, width: 60.w, color: AppColors.of(context).neutralColor12,),
                  ), //TODO: Gửi đến...
                IconButton(
                  onPressed: () {}, 
                  icon: SvgPicture.asset(Assets.icons.download2SVG)) //TODO: Lưu vào may
              ],
            ),
            widget.users.isNotEmpty ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.users.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(context.watch<UserProvider>().friendList.length, (index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  widget.users[index].avatar!,
                                  height: 16.w,
                                  width: 16.w,
                                  fit: BoxFit.cover
                                )
                              ),
                              Text(widget.users[index].fullName, style: AppTextStyles.of(context).light16.copyWith(color: AppColors.of(context).neutralColor11, fontSize: 16))
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                }
              ),
            ) : const CircularProgressIndicator()
          ]
        ),
      ),
    );
  }
}