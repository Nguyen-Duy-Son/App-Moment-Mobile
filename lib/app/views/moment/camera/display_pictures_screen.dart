import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:image/image.dart' as img;
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/app_bar_widget.dart';
import 'package:hit_moments/app/custom/widgets/app_snack_bar.dart';
import 'package:hit_moments/app/custom/widgets/custom_dialog.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/models/user_model.dart';
import 'package:hit_moments/app/providers/list_moment_provider.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:hit_moments/app/providers/music_provider.dart';
import 'package:hit_moments/app/providers/weather_provider.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
// import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

class _DisplayPictureScreenState extends State<DisplayPictureScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //Controller
  late TextEditingController feelingController;
  late TextEditingController imageController;
  late TextEditingController weatherController;
  late TextEditingController locationController;
  late TextEditingController userNameController;
  late TextEditingController createAtController;
  late TextEditingController updateAtController;
  late TextEditingController imgAvatarController;
  bool checkWeather = false;
  String? weather;
  int? playingIndex;
  AudioPlayer audioPlayer = AudioPlayer();
  String? nameMusic;
  String? musicId;
  late XFile editedImage;
  String? linkMusic;
  bool isUploading = false; // Kiểm soát trạng thái tải
  double uploadProgress = 0.0; // Giá trị phần trăm tải
  late AnimationController _animationController;

  Future<void> checkAndSaveImage(String imagePath) async {
    // Check the current status of the storage permission
    var status = await Permission.photos.status;

    if (status.isGranted) {
      // If permission is granted, save the image to the gallery
      await saveImageToGallery(imagePath);
    }
    if (status.isDenied) {
      // If permission is denied, request it
      _showError();
    }
    if (status.isPermanentlyDenied) {
      _showError();
    }
  }

  void _showError() {
    showCustomDialog(
      context,
      title: S.of(context).error,
      content: Text(
        S.of(context).errorStorage,
        style: AppTextStyles.of(context)
            .regular24
            .copyWith(color: AppColors.of(context).neutralColor12),
        textAlign: TextAlign.center,
      ),
      backgroundPositiveButton: AppColors.of(context).primaryColor10,
      textPositive: S.of(context).ok,
      onPressPositive: () async {
        Navigator.of(context).pop();
        await openAppSettings();
      },
      colorTextPositive: AppColors.of(context).primaryColor1,
      hideNegativeButton: true,
    );
  }

  Future<void> saveImageToGallery(String imagePath) async {
    final result = await ImageGallerySaver.saveFile(imagePath);
    if (result['isSuccess']) {
      // if mounted
      if (mounted) {
        AppSnackBar.showSuccess(context, S.of(context).saveImageSuccess);
      }
    } else {
      // if mounted
      if (mounted) {
        AppSnackBar.showError(
            context, S.of(context).error, S.of(context).saveImageFail);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<ListMomentProvider>().getListMoment();
      context.read<MusicProvider>().getListMusic();
    });
    if (context.read<WeatherProvider>().weatherStatus == ModuleStatus.initial) {
      context.read<WeatherProvider>().getCurrentPosition();
    }
    editedImage = XFile(widget.image.path);
    // Khởi tạo AnimationController
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Thời gian hiệu ứng
      vsync: this,
    );
  }

  void initController() {
    feelingController = TextEditingController();
    imageController = TextEditingController();
    weatherController = TextEditingController();
    locationController = TextEditingController();
    userNameController = TextEditingController();
    createAtController = TextEditingController();
    updateAtController = TextEditingController();
    imgAvatarController = TextEditingController();
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Dispose the audio player
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, MomentProvider value, Widget? child) {
        // if (value.createMomentStatus == ModuleStatus.fail) {
        //   AppSnackBar.showError(context, S.of(context).error,
        //       S.of(context).error + S.of(context).createMomentFail);
        // }
        return Opacity(
          opacity: (value.createMomentStatus == ModuleStatus.loading && isUploading == true) ? 0.5 : 1,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.of(context).neutralColor1,
            appBar: AppBarWidget(
              title: S.of(context).sendto,
              action: Padding(
                padding: EdgeInsets.only(right: 16.w, bottom: 8.w),
                child: GestureDetector(
                  onTap: () async {
                    await checkAndSaveImage(widget.image.path);
                  },
                  child: SvgPicture.asset(
                    Assets.icons.download2SVG,
                    color: AppColors.of(context).neutralColor12,
                    width: 36.w,
                    height: 36.w,
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      _buildHeaderPicture(),
                      SizedBox(height: 50.w),
                      SizedBox(height: 50.h),
                      _buildBottomScreen(),
                    ],
                  ),
                  if(value.createMomentStatus == ModuleStatus.loading && isUploading == true)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            S.of(context).postMoment,
                            style: AppTextStyles.of(context).light24.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          LoadingDotsAnimation(), // Thêm animation ba chấm nhảy
                        ],
                      ),
                    ),
                ]
              ),
            ),
          ),
        );
      },
    );
  }


  Future<void> _openImageEditor() async {
    // Read the current image file as bytes
    final imageBytes = await File(editedImage.path).readAsBytes();

    // Decode the image to manipulate it
    final decodedImage = img.decodeImage(imageBytes);
    if (decodedImage != null) {
      // Resize the image before opening the editor (reduce size by 50%)
      final resizedImage = img.copyResize(
        decodedImage,
        width: (decodedImage.width * 0.5).toInt(), // Reduce width by 50%
        height: (decodedImage.height * 0.5).toInt(), // Reduce height by 50%
      );

      // Encode the resized image back to bytes
      final resizedImageBytes = img.encodePng(resizedImage);

      // Open the resized image in the editor
      final editedFileBytes = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: resizedImageBytes,
          ),
          fullscreenDialog: true,
        ),
      );

      // If an edited image is returned, save it to a new file and update the state
      if (editedFileBytes != null) {
        final tempDir = await getTemporaryDirectory();
        final filePath =
            '${tempDir.path}/edited_image_${DateTime.now().millisecondsSinceEpoch}.png';
        final editedFileInstance =
        await File(filePath).writeAsBytes(editedFileBytes);

        setState(() {
          // Update to the new edited image
          editedImage = XFile(editedFileInstance.path);
        });
      }
    }
  }

  Widget _buildEditImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _openImageEditor,
        ),
      ],
    );
  }

  Widget _buildPicture() {
    return Padding(
      padding: EdgeInsets.only(top: 80.h, left: 4.w, right: 4.w),
      child: SizedBox(
        height: 1.sw - 16.w,
        width: 1.sw - 16.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.w),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.file(
              File(editedImage.path),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
          ),
        ),
      ),
      // child: AspectRatio(
      //   aspectRatio: 3 / 4,
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(50),
      //     child: Image.file(
      //       File(editedImage.path),
      //       fit: BoxFit.cover,
      //       errorBuilder: (context, error, stackTrace) {
      //         return const Icon(Icons.error, color: Colors.red);
      //       },
      //     ),
      //   ),
      // ),
    );
  }

  void showModalSheetSelectMusic(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final musicProvider = context.watch<MusicProvider>();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter set) {
            return Container(
              padding: EdgeInsets.all(16.w),
              child: musicProvider.isLoadingListMusic
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor6,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.searchNameMusic,
                              hintStyle: AppTextStyles.of(context)
                                  .light20
                                  .copyWith(
                                      color:
                                          AppColors.of(context).neutralColor12),

                              contentPadding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 16.w,
                                  top: 6.w,
                                  bottom: 6.w),
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  // musicProvider.searchMusic();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  margin: EdgeInsets.only(right: 8.w),
                                  child: SvgPicture.asset(
                                    Assets.icons.search,
                                    color: AppColors.of(context).neutralColor10,
                                  ),
                                ),
                              ),
                            ),
                            style: AppTextStyles.of(context)
                                .light20
                                .copyWith(color: AppColors.of(context).neutralColor12),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: musicProvider.musics.length,
                            itemBuilder: (context, index) {
                              final music = musicProvider.musics[index];
                              bool isPlaying = playingIndex == index;
                              return ListTile(
                                onTap: () {
                                  set(() {
                                    if (playingIndex == index) {
                                      playingIndex = null;
                                      audioPlayer.stop();
                                      setState(() {
                                        nameMusic = null;
                                        musicId = null;
                                        linkMusic = null;
                                      }); // Stop the music
                                    } else {
                                      playingIndex = index;
                                      audioPlayer.play(UrlSource(
                                          music.linkMusic)); // Play the music
                                      setState(() {
                                        nameMusic = music.name;
                                        musicId = music.id;
                                        linkMusic = music.linkMusic;
                                      });
                                    }
                                  });
                                },
                                title: Row(
                                  children: [
                                    isPlaying
                                        ? Image.asset(
                                            Assets.icons.musicGif,
                                            width: 20.w,
                                            height: 20.w,
                                            color: AppColors.of(context)
                                                .neutralColor12,
                                          )
                                        : const SizedBox(),
                                    Text(music.name,
                                        style: AppTextStyles.of(context)
                                            .light24
                                            .copyWith(
                                                color: AppColors.of(context)
                                                    .neutralColor12)),
                                  ],
                                ),
                                subtitle: Text(music.author,
                                    style: AppTextStyles.of(context)
                                        .light16
                                        .copyWith(
                                            color: AppColors.of(context)
                                                .neutralColor9)),
                                trailing: GestureDetector(
                                  onTap: () {
                                    set(() {
                                      if (playingIndex == index) {
                                        playingIndex = null;
                                        audioPlayer.stop();
                                        setState(() {
                                          nameMusic = null;
                                          musicId = null;
                                        }); // Stop the music
                                      } else {
                                        playingIndex = index;
                                        audioPlayer.play(UrlSource(
                                            music.linkMusic)); // Play the music
                                        setState(() {
                                          nameMusic = music.name;
                                          musicId = music.id;
                                        });
                                      }
                                    });
                                  },
                                  child: isPlaying
                                      ? SvgPicture.asset(
                                          Assets.icons.pause,
                                          color: AppColors.of(context)
                                              .primaryColor10,
                                          width: 24.w,
                                          height: 24.w,
                                        )
                                      : SvgPicture.asset(
                                          Assets.icons.playMusic,
                                          color: AppColors.of(context)
                                              .neutralColor10,
                                          width: 24.w,
                                          height: 24.w,
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  Future<void> createMoment() async {
    final momentProvider = context.read<MomentProvider>();

    // Nếu không có thông tin thời tiết
    weather = checkWeather ? weatherController.text : "";

    setState(() {
      isUploading = true; // Hiển thị widget loading
      uploadProgress = 0.0; // Bắt đầu từ 0%
    });

    // Chạy song song giữa cập nhật progress và gọi API
    await momentProvider.createMoment(
        content: feelingController.text,
        weather: weather,
        image: editedImage,
        musicId: musicId,
        linkMusic: linkMusic,
        type: getStringTypeMoment(TypeMoment.image),
      );

    // Sau khi API hoàn tất, cập nhật progress lên 100%
    if (momentProvider.createMomentStatus == ModuleStatus.success) {
      setState(() {
        isUploading = false; // Ẩn widget loading
      });

      Navigator.of(context).pop(); // Đóng màn hình
      AppSnackBar.showSuccess(context, S.of(context).createMomentSuccess);
    } else if (momentProvider.createMomentStatus == ModuleStatus.fail) {
      setState(() {
        isUploading = false; // Ẩn widget loading
      });
      AppSnackBar.showError(
          context, S.of(context).error, S.of(context).createMomentFail);
    }
  }


  Widget _buildHeaderPicture() {
    return Form(
      key: _globalKey,
      child: Stack(alignment: Alignment.topRight, children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildPicture(),
            !context.watch<MusicProvider>().isLoadingListMusic
                ? Positioned(
                    top: 80.w,
                    child: GestureDetector(
                      onTap: () {
                        showModalSheetSelectMusic(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor11,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 4.w),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.icons.music,
                              width: 14.w,
                              height: 14.w,
                              color: AppColors.of(context).neutralColor1,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              nameMusic != null
                                  ? nameMusic!
                                  : AppLocalizations.of(context)!.addMusic,
                              style: AppTextStyles.of(context).light14.copyWith(
                                  color: AppColors.of(context).neutralColor1),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Consumer<WeatherProvider>(
                builder: (context, weatherProvider, child) {
              if (weatherProvider.weatherStatus != ModuleStatus.initial) {
                weatherController.text =
                    "${weatherProvider.weather?.city}|${weatherProvider.weather?.tempC}|${weatherProvider.weather?.icon}";
                return checkWeather
                    ? Positioned(
                        top: 88.w,
                        right: 10.w,
                        width: weatherProvider.weather?.icon == null
                            ? MediaQuery.of(context).size.width / 3.5
                            : MediaQuery.of(context).size.width / 2.7,
                        child: Row(
                          children: [
                            weatherProvider.weather?.icon == null
                                ? SvgPicture.asset(Assets.icons.sunSVG,
                                    height: 14.w, width: 12.w)
                                : CachedNetworkImage(
                                    imageUrl:
                                        "https:${weatherProvider.weather?.icon}",
                                    fit: BoxFit.cover,
                                  ),
                            SizedBox(width: 2.w),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        color:
                                            AppColors.of(context).neutralColor1,
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
                                          .regular16
                                          .copyWith(
                                        height: 1,
                                        color:
                                            AppColors.of(context).neutralColor3,
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
                            ),
                          ],
                        ),
                      )
                    : const SizedBox();
              } else {
                return const SizedBox();
              }
            }),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 88.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.of(context).neutralColor7,
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: TextFormField(
                enableSuggestions: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'.*')), // Cho phép mọi ký tự
                ],
                keyboardType: TextInputType.text, // Loại bàn phím hỗ trợ ký tự văn bản
                textInputAction: TextInputAction.done, // Kiểu hành động nút trên bàn phím
                autocorrect: true,
                controller: feelingController,
                style: AppTextStyles.of(context)
                    .light20
                    .copyWith(color: AppColors.of(context).neutralColor12, height: 1),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textAlignVertical: TextAlignVertical.center,
                cursorHeight: 20.h,
                cursorColor: AppColors.of(context).neutralColor10,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.feel,
                  isCollapsed: true, // Bắt buộc không thêm padding mặc định
                  hintStyle: AppTextStyles.of(context)
                      .light16
                      .copyWith(color: AppColors.of(context).neutralColor1),
                  contentPadding: EdgeInsets.only(
                      left: 12.w, right: 8.w, top: 7.w, bottom: 4.w),
                  counterStyle: AppTextStyles.of(context)
                      .light16
                      .copyWith(color: AppColors.of(context).neutralColor12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.w),
                    borderSide: BorderSide(color: AppColors.of(context).neutralColor7),
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderSide:  BorderSide(color: AppColors.of(context).neutralColor7), borderRadius: BorderRadius.circular(20.w)),
                  enabledBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: AppColors.of(context).neutralColor7),
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: AppColors.of(context).neutralColor7),
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  counterText: "", // Add this line
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildBottomScreen() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () async {
            Navigator.of(context).pop();
          },
          child: SvgPicture.asset(
            Assets.icons.remove,
            color: AppColors.of(context).neutralColor12,
            width: 36.w,
            height: 36.w,
          ),
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
                  color: AppColors.of(context).primaryColor10, width: 4),
              padding: const EdgeInsets.fromLTRB(4, 6, 12, 2)),
          child: SvgPicture.asset(
            Assets.icons.sendSVG,
            height: 60.w,
            width: 60.w,
            color: AppColors.of(context).neutralColor12,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              checkWeather = !checkWeather;
            });
          },
          child: !checkWeather
              ? SvgPicture.asset(
                  Assets.icons.cloud1SVG,
                  color: AppColors.of(context).neutralColor12,
                )
              : SvgPicture.asset(Assets.icons.cloud2SVG),
        ),
      ],
    );
  }

}
class LoadingDotsAnimation extends StatefulWidget {
  @override
  _LoadingDotsAnimationState createState() => _LoadingDotsAnimationState();
}

class _LoadingDotsAnimationState extends State<LoadingDotsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    // Controller cho hoạt ảnh
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900), // Tốc độ tổng thể
      vsync: this,
    )..repeat();

    // Ba hoạt ảnh chồng lấp nhau
    _animation1 = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );

    _animation2 = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeInOut),
      ),
    );

    _animation3 = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation1,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation1.value,
              child: _buildDot(color: Colors.white),
            );
          },
        ),
        const SizedBox(width: 8),
        AnimatedBuilder(
          animation: _animation2,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation2.value,
              child: _buildDot(color: Colors.white),
            );
          },
        ),
        const SizedBox(width: 8),
        AnimatedBuilder(
          animation: _animation3,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation3.value,
              child: _buildDot(color: Colors.white),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDot({required Color color}) {
    return Container(
      width: 12, // Kích thước của dấu chấm
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// class LoadingDotsAnimation extends StatefulWidget {
//   const LoadingDotsAnimation({super.key});
//
//   @override
//   _LoadingDotsAnimationState createState() => _LoadingDotsAnimationState();
// }
//
// class _LoadingDotsAnimationState extends State<LoadingDotsAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation1;
//   late Animation<double> _animation2;
//   late Animation<double> _animation3;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Controller cho hoạt ảnh
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 600), // Tốc độ tổng thể
//       vsync: this,
//     )..repeat(reverse: true);
//
//     // Ba hoạt ảnh với thời gian chồng lấp mượt mà
//     _animation1 = Tween<double>(begin: 0, end: -10).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
//       ),
//     );
//
//     _animation2 = Tween<double>(begin: 0, end: -10).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.2, 0.6, curve: Curves.easeInOut),
//       ),
//     );
//
//     _animation3 = Tween<double>(begin: 0, end: -10).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         AnimatedBuilder(
//           animation: _animation1,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(0, _animation1.value),
//               child: _buildDot(),
//             );
//           },
//         ),
//         const SizedBox(width: 8),
//         AnimatedBuilder(
//           animation: _animation2,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(0, _animation2.value),
//               child: _buildDot(),
//             );
//           },
//         ),
//         const SizedBox(width: 8),
//         AnimatedBuilder(
//           animation: _animation3,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(0, _animation3.value),
//               child: _buildDot(),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDot() {
//     return Container(
//       width: 8,
//       height: 8,
//       decoration: const BoxDecoration(
//         color: ColorConstants.primaryLight10,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }



// Mở giao diện chỉnh sửa ảnh từ image_editor_plus
// Open the image editor and update the displayed image on return
// Future<void> _openImageEditor() async {
//   // Read the current image file as bytes
//   final imageBytes = await File(editedImage.path).readAsBytes();
//
//   // Open the image editor and wait for the edited image bytes
//   final editedFileBytes = await Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (context) => Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: SafeArea(
//           child: ImageEditor(
//             image: imageBytes,
//           ),
//         ),
//       ),
//       fullscreenDialog: true,
//     ),
//   );
//
//
//   // If an edited image is returned, save it to a new file and update the state
//   if (editedFileBytes != null) {
//     final tempDir = await getTemporaryDirectory();
//     final filePath =
//         '${tempDir.path}/edited_image_${DateTime.now().millisecondsSinceEpoch}.png';
//     final editedFileInstance =
//         await File(filePath).writeAsBytes(editedFileBytes);
//
//     setState(() {
//       // Update to the new edited image
//       editedImage = XFile(editedFileInstance.path);
//     });
//   }
// }


// Future<void> createMoment() async {
//   final momentProvider = context.read<MomentProvider>();
//
//   // Nếu không có thông tin thời tiết
//   weather = checkWeather ? weatherController.text : "";
//
//   setState(() {
//     isUploading = true; // Hiển thị widget loading
//     uploadProgress = 0.0; // Bắt đầu từ 0%
//   });
//
//   // Chạy song song giữa cập nhật progress và gọi API
//   await Future.wait([
//     // 1. Hiển thị progress giả lập đến 90%
//     Future(() async {
//       for (int i = 0; i <= 90; i++) {
//         await Future.delayed(const Duration(milliseconds: 30)); // Giả lập delay
//         setState(() {
//           uploadProgress = i.toDouble(); // Cập nhật phần trăm
//         });
//       }
//     }),
//
//     // 2. Gọi API
//     momentProvider.createMoment(
//       content: feelingController.text,
//       weather: weather,
//       image: editedImage,
//       musicId: musicId,
//       linkMusic: linkMusic,
//       type: getStringTypeMoment(TypeMoment.image),
//     ),
//   ]);
//
//   // Khi API hoàn tất, tiếp tục tăng progress đến 100%
//   if (momentProvider.createMomentStatus == ModuleStatus.success) {
//     for (int i = 91; i <= 100; i++) {
//       await Future.delayed(const Duration(milliseconds: 20)); // Tăng dần từ 90% đến 100%
//       setState(() {
//         uploadProgress = i.toDouble();
//       });
//     }
//
//     // Khi hoàn tất, thoát màn hình và thông báo thành công
//     setState(() {
//       isUploading = false; // Ẩn widget loading
//     });
//     Navigator.of(context).pop(); // Đóng màn hình
//     AppSnackBar.showSuccess(context, S.of(context).createMomentSuccess);
//   } else if (momentProvider.createMomentStatus == ModuleStatus.fail) {
//     setState(() {
//       isUploading = false; // Ẩn widget loading
//     });
//     AppSnackBar.showError(
//         context, S.of(context).error, S.of(context).createMomentFail);
//   }
// }


// Future<void> createMoment() async {
//   final momentProvider = context.read<MomentProvider>();
//   if (checkWeather == false) {
//     weather = "";
//   } else {
//     weather = weatherController.text;
//   }
//   // feelingController.text, weather, editedImage, musicId, linkMusic, getStringTypeMoment(TypeMoment.image)
//   await momentProvider.createMoment(
//     content: feelingController.text,
//     weather: weather,
//     image: editedImage,
//     musicId: musicId,
//     linkMusic: linkMusic,
//     type: getStringTypeMoment(TypeMoment.image),
//       );
//   if(momentProvider.createMomentStatus == ModuleStatus.success){
//     Navigator.of(context).pop();
//     AppSnackBar.showSuccess(context, S.of(context).createMomentSuccess);
//   }
//   else if(momentProvider.createMomentStatus == ModuleStatus.fail){
//     AppSnackBar.showError(context, S.of(context).error, S.of(context).error + S.of(context).createMomentFail);
//   }
// }