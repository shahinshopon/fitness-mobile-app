import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness/ui/route/routes.dart';
import 'package:fitness/ui/style/styles.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Auth {
  
  final box = GetStorage();

  uploadImageToStroage(image, email, password, userName, context) async {
    try {
      AppStyles().progressDialog(context);
      print('00');
      File imageFile = File(image!.path);
      print('11');
      FirebaseStorage storage = FirebaseStorage.instance;
      UploadTask uploadTask =
          storage.ref('profile-images').child(image!.name).putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      registration(imageUrl, email, password, userName);
    } catch (e) {
      Get.back();
      Get.showSnackbar(AppStyles().failedSnackBar('Something is wrong'));
    }
  }

  Future registration(imageUrl, email, password, userName) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var authCredential = userCredential.user;
      if (authCredential!.uid.isNotEmpty) {
        CollectionReference registerData =
            FirebaseFirestore.instance.collection("users");
        registerData
            .doc(email)
            .set({
              "email": email,
              "user_name": userName,
              "profile": imageUrl,
            })
            .then((value) {
              box.write('uid', authCredential.uid);
              box.write('email', email);
              box.write('user_name', userName);
              box.write('profile', imageUrl);
            })
            .then((value) => Get.back())
            .then(
              (value) => Get.showSnackbar(
                  AppStyles().successSnackBar('Registration Successfull.')),
            )
            .then((value) => Get.toNamed(bottomNavController));
      } else {
        Get.back();
        Get.showSnackbar(
            AppStyles().failedSnackBar('Failed! Something is wrong.'));
      }
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        Get.back();
        Get.showSnackbar(
          AppStyles().failedSnackBar('Your Password is weak.'),
        );
      } else if (e.code == 'email-already-in-use') {
        Get.back();
        Get.showSnackbar(
          AppStyles()
              .failedSnackBar('The account already exists for that email.'),
        );
      }
    } catch (e) {
      Get.back();
      Get.showSnackbar(
        AppStyles().failedSnackBar('Failed! Something is wrong.'),
      );
    }
  }

  Future login(String email, String password, context) async {
    try {
      AppStyles().progressDialog(context);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var authCredential = userCredential.user;
      if (authCredential!.uid.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> doc) {
          if (doc.exists) {
            // print('Document data: ${documentSnapshot.data()}');
            var data = doc.data();
            box.write('uid', authCredential.uid);
            box.write('email', data!['email']);
            box.write('user_name', data['user_name']);
            box.write('profile', data['profile']);
          } else {
            Get.showSnackbar(
              AppStyles()
                  .failedSnackBar('Document does not exist on the database'),
            );
          }
        });

        // await box.write('uid', authCredential.uid);

        Get.back();
        Get.showSnackbar(
          AppStyles().successSnackBar('Login Successfull.'),
        );
        Get.toNamed(bottomNavController);
      } else {
        Get.back();
        Get.showSnackbar(
          AppStyles().failedSnackBar('Something is wrong.'),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.back();
        Get.showSnackbar(
          AppStyles().failedSnackBar('No user found for that email.'),
        );
      } else if (e.code == 'wrong-password') {
        Get.back();
        Get.showSnackbar(
          AppStyles().failedSnackBar('Wrong password provided for that user.'),
        );
      }
    } catch (e) {
      Get.back();
      Get.showSnackbar(
        AppStyles().failedSnackBar('Failed! Something is wrong.'),
      );
    }
  }

  Future resetPassword(email, context) async {
    try {
      AppStyles().progressDialog(context);
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      Get.back();
      Get.showSnackbar(
        AppStyles().successSnackBar('email has been sent to $email.'),
      );
    } on FirebaseAuthException catch (e) {
      Get.back();
      Get.showSnackbar(
        AppStyles().failedSnackBar('something is wrong.'),
      );
    }
  }


}
