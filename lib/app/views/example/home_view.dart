import 'package:flutter/material.dart';
import 'package:hit_moments/app/views/moment/camera/take_pictures_screen.dart';
import 'package:hit_moments/app/views/moment/moment_view.dart';
import 'package:hit_moments/app/views/profile/personalPageView.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: PageView(
            scrollDirection: Axis.vertical,
            children: [
              TakePictureScreen(),
              MomentView()
            ],
          ),
        )
    );
  }
}
