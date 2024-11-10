import 'package:flutter/material.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:hit_moments/app/views/example/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      _checkLogin();
    });
    super.initState();
  }
  void _checkLogin(){
    if(getToken().isNotEmpty){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
          ModalRoute.withName(AppRoutes.MY_HOME));
    }
    else{
      Navigator.popAndPushNamed(context, AppRoutes.AUTHENTICATION);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Assets.images.logoSplashPNG,
          height: 110,
          width: 110,
        ),
      ),
    );
  }
}
