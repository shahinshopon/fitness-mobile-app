import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class AppStyles {
  // onboarding
  BoxDecoration decoration(color) => BoxDecoration(
        color: color,
      );

  // loading
  progressDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Image.asset(
            "assets/files/loading.gif",
            height: 150,
          ),
        );
      },
      barrierDismissible: false,
    );
  }

  // failed snackbar
  GetSnackBar failedSnackBar(message) => GetSnackBar(
        message: message,
        backgroundColor: Colors.redAccent,
        duration: Duration(
          seconds: 2,
        ),
        icon: Icon(Icons.warning),
      );

 // success snackbar
   GetSnackBar successSnackBar(message) => GetSnackBar(
        message: message,
        backgroundColor: Colors.green,
        duration: Duration(
          seconds: 2,
        ),
        icon: Icon(Icons.assignment_turned_in_outlined),
      );

}
