import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:fitness/const/app_colors.dart';
import 'package:fitness/ui/views/home/pages/bottom_challenges.dart';
import 'package:fitness/ui/views/home/pages/bottom_home.dart';
import 'package:fitness/ui/views/home/pages/bottom_media.dart';
import 'package:fitness/ui/views/home/pages/bottom_profile.dart';
import 'package:fitness/ui/views/home/pages/bottom_search.dart';
import 'package:fitness/ui/views/quiz/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends StatelessWidget {
  BottomNavController({super.key});
  RxInt _initialIndex = 0.obs;

  final _pages = [
    BottomHome(),
    QuizScreen(),
   // BottomChallenges(),
    BottomMedia(),
    BottomSearch(),
    BottomProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    return Scaffold(
      bottomNavigationBar: Obx(() => AnimatedNotchBottomBar(
            // color: Get.isDarkMode == true ? AppColors.dark : Colors.white,
            color:
                brightness == Brightness.dark ? AppColors.dark : Colors.white,

            pageController: PageController(
              initialPage: _initialIndex.value,
            ),
            bottomBarItems: [
              navItem(Icons.home_filled),
              navItem(Icons.assessment_outlined),
              navItem(Icons.apps_outlined),
              navItem(Icons.search_outlined),
              navItem(Icons.person_outlined),
            ],
            onTap: (int value) {
              _initialIndex.value = value;
            },
          )),
      body: SafeArea(
        child: Obx(
          () => _pages[_initialIndex.value],
        ),
      ),
    );
  }
}

BottomBarItem navItem(inActiveIcon) {
  return BottomBarItem(
    inActiveItem: Icon(
      inActiveIcon,
      color: Colors.blueGrey,
    ),
    activeItem: Icon(
      inActiveIcon,
      color: AppColors.amber,
    ),
  );
}
