import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/models/moment_model.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/format_time_extension.dart';
import '../../../core/extensions/theme_extensions.dart';

class MomentContentWidget extends StatefulWidget {
  const MomentContentWidget({super.key, required this.momentModel});
  final MomentModel momentModel;

  @override
  State<MomentContentWidget> createState() => _MomentContentWidgetState();
}

class _MomentContentWidgetState extends State<MomentContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 3/4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.w),
            child: Image.network(widget.momentModel.image!, fit: BoxFit.fill,),
          ),
        ),
        Positioned(
          top: 16.w,
          left: 16.w,
          width: MediaQuery.of(context).size.width/2,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100))
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.w),
                  child: CachedNetworkImage(
                    imageUrl: widget.momentModel.imgAvatar??"",
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 8.w,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.momentModel.userName??"",
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
                    Text(FormatTimeExtension().formatTimeDifference(widget.momentModel.createAt!),
                      style: AppTextStyles.of(context).light14.copyWith(
                        color: AppColors.of(context).neutralColor8,
                        shadows: [
                          Shadow(
                            blurRadius: 1.0,
                            color: AppColors.of(context).neutralColor12,
                          ),
                        ],
                      ),)
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 16.w,
          right: 0,
          width: MediaQuery.of(context).size.width/3.5,
          child: Row(
            children: [
              SvgPicture.asset(Assets.icons.sunSVG),
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
                        widget.momentModel.uploadLocation??"",
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
                      Text("29 độ C",
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
        ),
        if(widget.momentModel.content!=null)
          Positioned(
            bottom: 16.w,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                    color: AppColors.of(context).neutralColor6,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.of(context).neutralColor11,
                          blurRadius: 5.h,
                          offset: Offset(0, 3.h)
                      )
                    ]
                ),
                child: Text(widget.momentModel.content!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.of(context).light24.copyWith(
                      color: AppColors.of(context).neutralColor12
                  ),
                ),
              ),
            ),
          )

      ],
    );
  }
}
