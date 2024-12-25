import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../models/moment_model.dart';
import '../../../providers/list_moment_provider.dart';

class GridViewMoment extends StatefulWidget {
  const GridViewMoment({super.key, required this.listMoment, required this.onSelected});
  final List<MomentModel> listMoment;
  final void Function(MomentModel, int) onSelected;
  @override
  State<GridViewMoment> createState() => _GridViewMomentState();
}

class _GridViewMomentState extends State<GridViewMoment> {

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<ListMomentProvider>().loadMoreListMoment();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      color: AppColors.of(context).neutralColor1,
      child: GridView.builder(
        itemCount: widget.listMoment.length,
          controller: _scrollController,
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h
          ),
          itemBuilder: (context, index) {
          // late VideoPlayerController videoPlayerController;
          //   if(widget.listMoment[index].type == getStringTypeMoment(TypeMoment.video)){
          //     videoPlayerController = VideoPlayerController.network(widget.listMoment[index].video ?? '')
          //       ..initialize().then((_) {
          //         setState(() {});
          //       })
          //     ;
          //   }
          //   else{
          //     videoPlayerController = VideoPlayerController.network('')
          //       ..initialize().then((_) {
          //       })
          //     ;
          //   }
          return imgMoment(context, widget.listMoment[index], index);
        }
      ),
    );
  }
  Widget imgMoment(BuildContext context, MomentModel moment, int index) {
    return ScaleOnTapWidget(
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.w),
          child: moment.type == getStringTypeMoment(TypeMoment.image)
              ? CachedNetworkImage(
            imageUrl: moment.image ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: Skeletonizer(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
              : FutureBuilder<Uint8List?>(
            future: _generateThumbnail(moment.video ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20.w),
                      ),
                    ),
                  ),
                )
                ;
              } else if (snapshot.hasData) {
                return Stack(
                  children: [
                    Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 50.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                );
              }
            },
          ),
        ),
      ),
      onTap: (isSelect) {
        widget.onSelected(moment, index);
      },
    );
  }
  Future<Uint8List?> _generateThumbnail(String videoUrl) async {
    try {
      return await VideoThumbnail.thumbnailData(
        video: videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200, // Set kích thước tối đa cho thumbnail
        quality: 75,
      );
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }

//   Widget imgMoment(BuildContext context, MomentModel moment, int index) {
//     // late VideoPlayerController videoPlayerController;
//     //   if(widget.listMoment[index].type == getStringTypeMoment(TypeMoment.video)){
//     //     videoPlayerController = VideoPlayerController.network(widget.listMoment[index].video ?? '')
//     //       ..initialize().then((_) {
//     //         setState(() {});
//     //       })
//     //     ;
//     //   }
//     //   else{
//     //     videoPlayerController = VideoPlayerController.network('')
//     //       ..initialize().then((_) {
//     //       })
//     //     ;
//     //   }
//     return ScaleOnTapWidget(
// //moment.type == getStringTypeMoment(TypeMoment.image) ?
//         child:  AspectRatio(
//           aspectRatio: 3/4,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(20.w),
//             child: CachedNetworkImage(
//               imageUrl: moment.image ?? '',
//               fit: BoxFit.cover,
//               placeholder: (context, url) => Center(
//                 child: Skeletonizer(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                   ),
//                 ),
//               ),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//             )
//           ),
//         ),
//         //     :  SizedBox(
//         //   child: ClipRRect(
//         //     borderRadius: BorderRadius.circular(20.w),
//         //     child: videoPlayerController.value.isInitialized
//         //         ? SizedBox(
//         //       width: 200.w ,
//         //       height: 200.h,
//         //       child: FittedBox(
//         //         fit: BoxFit.fitWidth, // Video sẽ hiển thị toàn bộ mà không bị méo
//         //         child: SizedBox(
//         //           width: videoPlayerController.value.size.width,
//         //           height: videoPlayerController.value.size.height,
//         //           child: VideoPlayer(videoPlayerController),
//         //         ),
//         //       ),
//         //     )
//         //         : Container(
//         //       color: Colors.grey[300],
//         //     ),
//         //   ),
//         // ),
//         onTap: (isSelect) {
//           widget.onSelected(moment, index);
//         },
//     );
//   }
}
