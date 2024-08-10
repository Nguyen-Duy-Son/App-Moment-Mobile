import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/views/example/home_view.dart';

import '../../core/constants/assets.dart';
import '../../custom/widgets/scale_on_tap_widget.dart';
import '../../l10n/l10n.dart';
import '../../models/content_model.dart';
import '../../routes/app_routes.dart';

class Onbording extends StatefulWidget {
  const Onbording({super.key});

  @override
  _OnbordingState createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<UnbordingContent> contents = [
      UnbordingContent(
          title: S.of(context).onboardingTitle1,
          image: Assets.images.onboarding1PNG,
          discription: S.of(context).onboardingDescription1
      ),
      UnbordingContent(
          title: S.of(context).onboardingTitle2,
          image: Assets.images.onboarding2PNG,
          discription: S.of(context).onboardingDescription2
      ),
      UnbordingContent(
          title: S.of(context).onboardingTitle3,
          image: Assets.images.onboarding3PNG,
          discription: S.of(context).onboardingDescription3
      ),
    ];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: 200,
                      ),
                      Text(
                        contents[i].title,
                        style: AppTextStyles.of(context).bold32.copyWith(
                          color: AppColors.of(context).neutralColor12
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        contents[i].discription,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.of(context).light16.copyWith(
                            color: AppColors.of(context).neutralColor11
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                    (index) => buildDot(index, context),
              ),
            ),
          ),
          SizedBox(height: 24.h,),
          ScaleOnTapWidget(
            onTap: (isSelect) {
              if (currentIndex == contents.length - 1) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeView(),
                    ),
                    ModalRoute.withName(AppRoutes.MY_HOME));
              }
              _controller.nextPage(
                duration: Duration(milliseconds: 100),
                curve: Curves.bounceIn,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.of(context).primaryColor10,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Text(
                  currentIndex == contents.length - 1 ?
                  S.of(context).continueString
                      : S.of(context).next,
                  style: AppTextStyles.of(context).regular20.copyWith(
                      color: AppColors.of(context).neutralColor1
                  ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 100.h,),

        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}