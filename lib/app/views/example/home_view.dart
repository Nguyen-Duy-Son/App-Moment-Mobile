import 'package:flutter/material.dart';
import 'package:hit_moments/app/views/moment/camera/take_pictures_screen.dart';
import 'package:hit_moments/app/views/moment/moment_view.dart';
import 'package:hit_moments/app/views/profile/personalPageView.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().getMe();
    pageController.addListener(() {
      if (pageController.position.atEdge) {
        bool isTop = pageController.position.pixels == 0;
        if(isTop){

        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: PageView(
            controller: pageController,
            scrollDirection: Axis.vertical,
            children: [
              TakePictureScreen(pageParentController: pageController,),
              MomentView(pageParentController: pageController,)
            ],
          ),
        )
    );
  }
}
