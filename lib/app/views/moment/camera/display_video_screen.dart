import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:hit_moments/app/providers/list_moment_provider.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:hit_moments/app/providers/music_provider.dart';
import 'package:hit_moments/app/providers/weather_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
class DisplayVideoScreen extends StatefulWidget {
  final XFile videoFile;
  final double? widthVideo;
  final double? heightVideo;

  const DisplayVideoScreen({super.key, required this.videoFile, this.widthVideo, this.heightVideo});

  @override
  State<DisplayVideoScreen> createState() => _DisplayVideoScreenState();
}

class _DisplayVideoScreenState extends State<DisplayVideoScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //Controller
  late TextEditingController feelingController;
  bool _showPlayPauseButton = true;
  late VideoPlayerController _videoPlayerController;
  bool _isPlayingVideo = false;
  int? playingIndex;
  AudioPlayer audioPlayer = AudioPlayer();

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

  Future<void> createMoment() async {
    final momentProvider = context.read<MomentProvider>();
    try {
      // Convert the temporary video to mp4 first
      // XFile convertedVideo = await convertTmpToMp4(widget.videoFile.path);

      XFile convertedVideo = widget.videoFile;
      // Now pass the converted XFile to createMoment
      await momentProvider.createMoment(
        content: feelingController.text,
        video: convertedVideo,  // Use the path from the converted XFile
        type: getStringTypeMoment(TypeMoment.video),
      );

      if (momentProvider.createMomentStatus == ModuleStatus.success) {
        await context.read<ListMomentProvider>().getListMoment();
        Navigator.of(context).pop();
        AppSnackBar.showSuccess(context, S.of(context).createMomentSuccess);
      } else if (momentProvider.createMomentStatus == ModuleStatus.fail) {
        AppSnackBar.showError(context, S.of(context).error, S.of(context).createMomentFail);
      }
    } catch (e) {
      AppSnackBar.showError(context, S.of(context).error, "Video conversion failed: ${e.toString()}");
    }
  }


  Future<void> saveVideoToGallery(String videoPath) async {
    try {
      // Kiểm tra file có tồn tại không
      final file = File(videoPath);
      if (!await file.exists()) {
        throw Exception("File không tồn tại");
      }

      final result = await ImageGallerySaver.saveFile(
          videoPath,
          name: "HIT_VIDEO_${DateTime.now().millisecondsSinceEpoch}"
      );

      if (result != null && result['isSuccess']) {
        if (mounted) {
          AppSnackBar.showSuccess(context, "Video đã được lưu thành công");
        }
      } else {
        throw Exception("Lưu video thất bại");
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, "Lỗi", "Không thể lưu video: ${e.toString()}");
      }
    }
  }


  Future<void> checkAndSaveVideo(String videoPath) async {
    // Check the current status of the storage permission
    Permission permission = Platform.isIOS ? Permission.photos : Permission.storage;
    var status = await permission.status;
    if (status.isGranted) {
      // If permission is granted, save the video to the gallery
      await saveVideoToGallery(videoPath);
    }
    if (status.isDenied) {
      // If permission is denied, request it
      _showError();
    }
    if (status.isPermanentlyDenied) {
      _showError();
    }
  }

  @override
  void initState() {
    super.initState();
    // Khởi tạo VideoPlayerController từ videoFile.path

    initController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<ListMomentProvider>().getListMoment();
      context.read<MusicProvider>().getListMusic();
    });
    _videoPlayerController = VideoPlayerController.file(File(widget.videoFile.path))
      ..initialize().then((_) {
        setState(() {}); // Cập nhật giao diện sau khi video được khởi tạo
        // Chỉ play sau khi video đã được khởi tạo
        // _controller.play();
      });
      // ..setLooping(true);
    _videoPlayerController.addListener(() {
      // Kiểm tra nếu video đã kết thúc
      if (_videoPlayerController.value.position >= _videoPlayerController.value.duration) {
        setState(() {
          _isPlayingVideo = false;
          _showPlayPauseButton = true; // Hiển thị nút play khi video kết thúc
        });
      }
    });
    if (context.read<WeatherProvider>().weatherStatus == ModuleStatus.initial) {
      context.read<WeatherProvider>().getCurrentPosition();
    }
  }

  void initController() {
    feelingController = TextEditingController();
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Dispose of AudioPlayer
    feelingController.dispose(); // Dispose of the text controller
    super.dispose();
  }
  Future<void> _togglePlayPauseVideo() async {
    if (!_isPlayingVideo) {
      // Nếu video đang dừng hoặc đã xem hết, phát video
      await _videoPlayerController.play();
      setState(() {
        _isPlayingVideo = true;
        _showPlayPauseButton = false; // Ẩn nút play ngay khi phát video
      });
    } else {
      // Nếu video đang phát, dừng video
      await _videoPlayerController.pause();
      setState(() {
        _isPlayingVideo = false;
        _showPlayPauseButton = true; // Hiển thị nút play khi video dừng
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, MomentProvider value, Widget? child)
    {
      return Opacity(
        opacity: (value.createMomentStatus == ModuleStatus.loading) ? 0.5 : 1,
        child: Scaffold(
          backgroundColor: AppColors.of(context).primaryColor1,
          resizeToAvoidBottomInset: false,
          appBar: AppBarWidget(
            title: S.of(context).sendto,
          ),
          body: _videoPlayerController.value.isInitialized
              ? SafeArea(
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
                if(value.createMomentStatus == ModuleStatus.loading )
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
              ],
            ),
          )
              : const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    });
  }

  Widget _buildPicture() {
    return Padding(
      padding: EdgeInsets.only(top: 80.h, left: 4.w, right: 4.w),
      child: GestureDetector(
        onTap: _togglePlayPauseVideo,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 1.sw,
              width: 1.sw,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.w),
                child: _videoPlayerController.value.isInitialized
                    ? FittedBox(
                  fit: BoxFit.cover, // Hoặc BoxFit.contain nếu bạn muốn video co lại thay vì cắt xén
                  child: SizedBox(
                    width: widget.widthVideo ?? 0,
                    height: widget.heightVideo ?? 0,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                )
                    : const CircularProgressIndicator(),
              ),
            ),
            if (_showPlayPauseButton == true && _isPlayingVideo == false)
              Positioned(
                top: (1.sw - 48.w) / 2,
                right: 0,
                left: 0,
                child: Center(
                  child: GestureDetector(
                    // onTap: _togglePlayPauseVideo,
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.of(context).neutralColor6,
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/ic_play_video.svg',
                        width: 16.w,
                        height: 16.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderPicture() {
    return Form(
      key: _globalKey,
      child: Stack(alignment: Alignment.topRight, children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildPicture(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 88.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.of(context).neutralColor7,
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: TextFormField(
                enableSuggestions: false,
                autocorrect: false,
                controller: feelingController,
                style: AppTextStyles.of(context).light20.copyWith(
                    color: AppColors.of(context).neutralColor12, height: 1),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textAlignVertical: TextAlignVertical.center,
                cursorHeight: 20.h,
                cursorColor: AppColors.of(context).neutralColor10,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.feel,
                  isCollapsed: true,
                  // Bắt buộc không thêm padding mặc định
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
                    borderSide:
                        BorderSide(color: AppColors.of(context).neutralColor7),
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.of(context).neutralColor7),
                      borderRadius: BorderRadius.circular(20.w)),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.of(context).neutralColor7),
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.of(context).neutralColor7),
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

  // Future<XFile> convertTmpToMp4(String tmpVideoPath) async {
  //   try {
  //     // Ensure the file exists
  //     final file = File(tmpVideoPath);
  //     if (!file.existsSync()) {
  //       throw Exception('Temporary video file not found at $tmpVideoPath');
  //     }
  //
  //     // Create the output path with .mp4 extension
  //     String mp4VideoPath = tmpVideoPath.replaceAll('.temp', '.mp4');
  //
  //     // FFmpeg command with specific video and audio codec parameters
  //     String command = '-i "$tmpVideoPath" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k -strict experimental -shortest "$mp4VideoPath"';
  //
  //
  //     // Execute the FFmpeg command
  //     final session = await FFmpegKit.execute(command);
  //     final returnCode = await session.getReturnCode();
  //
  //     // Logs for debugging
  //     final allLogs = await session.getAllLogs();
  //     for (var log in allLogs) {
  //       print(log);
  //     }
  //
  //     // Check the return code to determine success
  //     if (returnCode!.isValueSuccess()) {
  //       print('Video conversion successful: $mp4VideoPath');
  //       return XFile(mp4VideoPath);
  //     } else {
  //       throw Exception('Video conversion failed. Return Code: $returnCode');
  //     }
  //   } catch (e) {
  //     print('Exception during video conversion: $e');
  //     // If conversion fails, return the original file
  //     return XFile(tmpVideoPath);
  //   }
  // }


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
          // onTap: () async {
          //   await checkAndSaveVideo(widget.videoFile.path);
          // },
          child: SvgPicture.asset(
            Assets.icons.download2SVG,
            color: AppColors.of(context).neutralColor12,
            width: 36.w,
            height: 36.w,
          ),
        )
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