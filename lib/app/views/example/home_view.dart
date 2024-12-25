// import 'package:flutter/material.dart';
// import 'package:hit_moments/app/views/moment/camera/take_pictures_screen.dart';
// import 'package:hit_moments/app/views/moment/moment_view.dart';
// import 'package:hit_moments/app/views/profile/personalPageView.dart';
// import 'package:provider/provider.dart';
//
// import '../../providers/user_provider.dart';
//
// class HomeView extends StatefulWidget {
//   const HomeView({super.key});
//
//   @override
//   State<HomeView> createState() => _HomeViewState();
// }
//
// class _HomeViewState extends State<HomeView> {
//   PageController pageController = PageController();
//   @override
//   void initState() {
//     super.initState();
//     context.read<UserProvider>().getMe();
//     pageController.addListener(() {
//       if (pageController.position.atEdge) {
//         bool isTop = pageController.position.pixels == 0;
//         if(isTop){
//
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: PageView(
//           controller: pageController,
//           scrollDirection: Axis.vertical,
//           children: [
//             TakePictureScreen(pageParentController: pageController,),
//             MomentView(pageParentController: pageController,)
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:hit_moments/app/views/moment/camera/take_pictures_screen.dart';
import 'package:hit_moments/app/views/moment/moment_view.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  PageController pageController = PageController();
  bool isAtMomentView = false;

  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().getMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          physics: isAtMomentView
              ? const NeverScrollableScrollPhysics() // Ngăn không cho vuốt
              : const ClampingScrollPhysics(), // Cho phép vuốt
          onPageChanged: (int pageIndex) {
            setState(() {
              // Kiểm tra nếu trang hiện tại là MomentView (index = 1)
              isAtMomentView = pageIndex == 1;
            });
          },
          children: [
            TakePictureScreen(
              pageParentController: pageController,
            ),
            MomentView(
              pageParentController: pageController,
            ),
          ],
        ),
      ),
    );
  }
}
