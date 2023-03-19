import 'package:fitness/model/onboarding.dart';
import 'package:fitness/ui/style/styles.dart';
import 'package:fitness/ui/widgets/onboarding_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  RxInt _initialIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => LiquidSwipe(
          pages: [
            onboardingItem(
              contents[0].image,
              contents[0].title,
              contents[0].discription,
              AppStyles().decoration(
                Colors.amber,
              ),
            ),
            onboardingItem(
              contents[1].image,
              contents[1].title,
              contents[1].discription,
              AppStyles().decoration(
                Colors.pink,
              ),
            ),
            onboardingItem(
              contents[2].image,
              contents[2].title,
              contents[2].discription,
              AppStyles().decoration(
                Colors.purple,
              ),
              index: _initialIndex.value,
            ),
          ],
          initialPage: _initialIndex.value,
          onPageChangeCallback: (activePageIndex) {
            _initialIndex.value = activePageIndex;
            print(_initialIndex.value);
          },
        ),
      ),
    );
  }
}
