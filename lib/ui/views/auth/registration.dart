import 'dart:io';
import 'package:fitness/business_logics/auth.dart';
import 'package:fitness/ui/style/styles.dart';
import 'package:fitness/ui/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../route/routes.dart';
import '../../widgets/custom_text_field.dart';

class Registration extends StatefulWidget {
  Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController _userNameController = new TextEditingController();

  final TextEditingController _emailController = new TextEditingController();

  final TextEditingController _passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  RxBool _passwordVisible = true.obs;

  XFile? image;

  pickGalleryImage() async {
    final ImagePicker picker = ImagePicker();
    image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 50,
                  left: 30,
                  right: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Let\'s start your journey\nwith us.',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'we will not share your information with others.',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Divider(),
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        clipBehavior: Clip.none,
                        children: [
                          Card(
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              child: image == null
                                  ? Icon(
                                      Icons.person_outlined,
                                      size: 40,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                      child: Image.file(
                                        File(image!.path),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            elevation: 5,
                          ),
                          Positioned(
                            bottom: -10,
                            child: InkWell(
                              onTap: () => pickGalleryImage(),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.purple,
                                radius: 20,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    customFormField(
                      TextInputType.text,
                      _userNameController,
                      context,
                      'user name',
                      (value) {
                        if (value == null || value.isEmpty) {
                          return "this field can't be empty";
                        } else if (value.length < 4) {
                          return "user name must be more than 4 character.";
                        }

                        return null;
                      },
                    ),
                    customFormField(
                      TextInputType.emailAddress,
                      _emailController,
                      context,
                      'write your email',
                      (value) {
                        if (value == null || value.isEmpty) {
                          return "this field can't be empty";
                        } else if (!value.contains(RegExp(r'\@'))) {
                          return "enter a valid email address";
                        } else if (!value.contains(RegExp(r'\.'))) {
                          return "enter a valid email address";
                        }

                        return null;
                      },
                    ),
                    Obx(
                      () => customFormField(
                        TextInputType.text,
                        _passwordController,
                        context,
                        'password',
                        (value) {
                          if (value == null || value.isEmpty) {
                            return "this field can't be empty";
                          } else if (value.length < 6) {
                            return "password at least 6 digit";
                          }
                          return null;
                        },
                        obscureText: _passwordVisible.value,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _passwordVisible.value = !_passwordVisible.value;
                          },
                          icon: Icon(
                            _passwordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    customButton(
                      'Continue',
                      () {
                        if (image == null) {
                          Get.showSnackbar(
                            AppStyles()
                                .failedSnackBar('Please upload an image!'),
                          );
                        } else if (_formKey.currentState!.validate()) {
                          final userName = _userNameController.text.trim();
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          Auth().uploadImageToStroage(
                              image, email, password, userName, context);
                        } else {
                          Get.showSnackbar(GetSnackBar(
                            title: 'Something is wrong.',
                          ));
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: RichText(
                          text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Get.isDarkMode == true
                                      ? Colors.white
                                      : Colors.black),
                              children: [
                            TextSpan(
                              text: 'Login Now',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Get.isDarkMode == true
                                      ? Colors.white
                                      : Colors.black),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.toNamed(login),
                            ),
                          ])),
                    ),
                  
                  
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
