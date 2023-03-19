import 'package:fitness/const/app_colors.dart';
import 'package:flutter/material.dart';

Widget customButton(
  String title,
  onPressed,
) {
  return Container(
    height: 45,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: AppColors.amber,
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.white,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 22,
            ),
          ),
        ),
      ),
    ),
  );
}
