import 'package:fitness/ui/responsive/size_config.dart';
import 'package:fitness/ui/route/routes.dart';
import 'package:fitness/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget onboardingItem(imgRef, title, description, decoration, {index}) {
  return Container(
    height: SizeConfig.screenHeight,
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 60,
          left: 30,
          right: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                imgRef,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            if (index == 2)
              customButton(
                'Continue',
                () => Get.toNamed(login),
              ),
          ],
        ),
      ),
    ),
    decoration: decoration,
  );
}
