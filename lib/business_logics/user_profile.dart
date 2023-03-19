import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness/ui/route/routes.dart';
import 'package:fitness/ui/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

class UserProfile {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final box = GetStorage();
  updateData(image, userName, email, context) async {
    if (image == null) {
      // update user name
      users
          .doc(email)
          .update({'user_name': userName})
          .then((value) => Get.showSnackbar(
              AppStyles().successSnackBar('Updated Successfully')))
          .catchError((error) => Get.showSnackbar(
              AppStyles().failedSnackBar('Failed to update.')));

      // store data locally
      box.write('user_name', userName);
    } else {
      try {
        AppStyles().progressDialog(context);

        File imageFile = File(image!.path);

        FirebaseStorage storage = FirebaseStorage.instance;
        UploadTask uploadTask =
            storage.ref('profile-images').child(image!.name).putFile(imageFile);

        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();
        users.doc(email).update({
          'user_name': userName,
          'profile': imageUrl,
        }).then((value) => Get.showSnackbar(
            AppStyles().successSnackBar('Updated Successfully')));
        box.write('user_name', userName);
        box.write('profile', imageUrl);
        Get.back();
      } catch (e) {
        Get.back();
        Get.showSnackbar(AppStyles().failedSnackBar('Something is wrong'));
      }
      // update image
      // update username
      // store data locally
    }
  }

  logOut(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 150,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are u sure to logout?',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          box.erase();
                          Get.showSnackbar(AppStyles().successSnackBar('Logout Successfull.'));
                          Get.toNamed(splash);
                        },
                        child: Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('No'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
