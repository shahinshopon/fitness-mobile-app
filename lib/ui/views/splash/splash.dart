import 'dart:ui';

import 'package:fitness/const/app_colors.dart';
import 'package:fitness/ui/responsive/size_config.dart';
import 'package:fitness/ui/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final box = GetStorage();
  chooseScreen() {
    var value = box.read('uid');
    if (value == null) {
      Get.toNamed(onboarding);
    } else {
      Get.toNamed(bottomNavController);
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () => chooseScreen(),);
   //Get.toNamed(homeScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Image.asset(
                'assets/files/splash.gif',
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: CircularProgressIndicator(color: AppColors.amber),
          )
        ],
      ),
    );
  }
}
