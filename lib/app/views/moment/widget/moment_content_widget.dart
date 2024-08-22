import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/models/moment_model.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/format_time_extension.dart';
import '../../../core/extensions/theme_extensions.dart';

class MomentContentWidget extends StatefulWidget {
  const MomentContentWidget({super.key, required this.momentModel});

  final MomentModel momentModel;

  @override
  State<MomentContentWidget> createState() => _MomentContentWidgetState();
}

class _MomentContentWidgetState extends State<MomentContentWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimationVisible = false;

  @override
  void initState() {
    super.initState();
    parseString(widget.momentModel.weather ?? "");
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isAnimationVisible = false;
          });
        }
      });
  }

  String? address;
  String? temperature;
  String? urlIcon;

  void parseString(String input) {
    print("alo$input");
    final regex = RegExp(r'^(.*?)\|(.*?)\|(.*?)$');

    if (regex.hasMatch(input)) {
      final match = regex.firstMatch(input);

      if (match != null) {
        address = match.group(1);
        temperature = match.group(2);
        urlIcon = match.group(3);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<MomentProvider>().sendReactStatus ==
        ModuleStatus.loading) {
      setState(() {
        _isAnimationVisible = true;
      });
      _controller.forward(from: 0);
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: AspectRatio(
            aspectRatio: 3/4,
            child: Image.network(
              widget.momentModel.image!,
              fit: BoxFit.fill,
              // width: 1.sw - 4.w,
              // height: 1.sw - 4.w,
            ),
          ),
        ),
        Positioned(
          top: 16.w,
          left: 16.w,
          width: MediaQuery.of(context).size.width / 2,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.w),
                  child: CachedNetworkImage(
                    imageUrl: widget.momentModel.imgAvatar ?? "",
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.momentModel.userName ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppTextStyles.of(context).regular16.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.of(context).neutralColor1,
                        shadows: [
                          const Shadow(
                            blurRadius: 1.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      FormatTimeExtension().formatTimeDifference(
                          widget.momentModel.createAt!, context),
                      style: AppTextStyles.of(context).light14.copyWith(
                        color: AppColors.of(context).neutralColor1,
                        shadows: [
                          Shadow(
                            blurRadius: 1.0,
                            color: AppColors.of(context).neutralColor12,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 16.w,
          right: 0,
          width: urlIcon == null
              ? MediaQuery.of(context).size.width / 3.5
              : MediaQuery.of(context).size.width / 2.7,
          child: Row(
            children: [
              urlIcon == null
                  ? SvgPicture.asset(Assets.icons.sunSVG)
                  : CachedNetworkImage(
                      imageUrl: "https:$urlIcon",
                      fit: BoxFit.cover,
                    ),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    color: AppColors.of(context).neutralColor6,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: EdgeInsets.only(left: 4.w, right: 4.w,top: 2.w, bottom: 2.w),
                  margin: EdgeInsets.only(right: 16.w),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        address ?? (widget.momentModel.uploadLocation ?? ""),
                        maxLines: 1,
                        style: AppTextStyles.of(context).light14.copyWith(
                          height: 1,
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
                      Text(
                        "${temperature ?? 29}℃",
                        style: AppTextStyles.of(context).regular16.copyWith(
                          height: 1,
                          color: AppColors.of(context).neutralColor3,
                          shadows: [
                            Shadow(
                              blurRadius: 1.0,
                              color: AppColors.of(context).neutralColor12,
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
        ),
        if (widget.momentModel.content != null)
          Positioned(
            bottom: 4.w,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
                decoration: BoxDecoration(
                    color: AppColors.of(context).neutralColor6,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.of(context).neutralColor11,
                          blurRadius: 5.h,
                          offset: Offset(0, 3.h))
                    ]),
                child: Text(
                  widget.momentModel.content!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.of(context)
                      .light24
                      .copyWith(color: AppColors.of(context).neutralColor12),
                ),
              ),
            ),
          ),
        if (_isAnimationVisible)
          Positioned.fill(
            child: Lottie.asset('assets/animations/react_heart1.json',
                fit: BoxFit.cover, controller: _controller),
          ),
      ],
    );
  }
}
