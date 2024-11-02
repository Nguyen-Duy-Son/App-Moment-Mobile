import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppPageWidget extends StatelessWidget {
  final bool isLoading;
  final Widget body;
  final VoidCallback? onRefresh;
  final PreferredSizeWidget? appbar;
  final VoidCallback? onGoBack;
  final bool? extendBodyBehindAppBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool showFullLoading;

  const AppPageWidget({
    super.key,
    this.isLoading = false,
    required this.body,
    this.onRefresh,
    this.appbar,
    this.onGoBack,
    this.extendBodyBehindAppBar = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.showFullLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: AppColors.of(context).primaryColor1,
        extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
        appBar: appbar,
        resizeToAvoidBottomInset: false,
        // ignore: deprecated_member_use
        body: WillPopScope(
          onWillPop: () {
            if (isLoading) {
              return Future.value(false);
            }
            if (onGoBack != null) {
              onGoBack!.call();
            }
            return Future.value(true);
          },
          child: body,
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
      isLoading ? _buildFullLoading(context) : const SizedBox(),
    ]);
  }

  Widget _buildFullLoading(context) {
    if (!showFullLoading) {
      return Container(
        width: 1.sw,
        height: 1.sh,
        color: Colors.transparent,
      );
    }

    return Positioned(
      width: 1.sw,
      height: 1.sh,
      child: Container(
        color: Colors.black54,
        child: Center(
          // Using a different loading animation
          child: LoadingAnimationWidget.discreteCircle(
            size: 60,
            color: AppColors.of(context).primaryColor9,
            secondRingColor: AppColors.of(context).primaryColor9,
            thirdRingColor: AppColors.of(context).primaryColor9,
          ),
        ),
      ),
    );
  }
}
