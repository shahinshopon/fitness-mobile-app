import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/business_logics/user_profile.dart';
import 'package:fitness/const/app_colors.dart';
import 'package:fitness/ui/widgets/custom_button.dart';
import 'package:fitness/ui/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../route/routes.dart';

class BottomProfile extends StatefulWidget {
  BottomProfile({super.key});

  @override
  State<BottomProfile> createState() => _BottomProfileState();
}

class _BottomProfileState extends State<BottomProfile> {
  final TextEditingController _userNameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? image;
  pickGalleryImage() async {
    final ImagePicker picker = ImagePicker();
    image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {});
  }

  final box = GetStorage();
  late String userEmail;

  @override
  void initState() {
    userEmail = box.read('email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => UserProfile().logOut(context),
            icon: IconTheme(
                data: Theme.of(context).copyWith().iconTheme,
                child: Icon(Icons.logout_outlined)),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 30,
                  right: 30,
                ),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userEmail)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      var data = snapshot.data;

                      if (snapshot.hasError) {
                        return Center(child: Text('Failed to load'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: AppColors.amber,
                          ),
                        );
                      }

                      return setUserData(data, context);
                    }),
              )),
        ),
      ),
    );
  }

  Widget setUserData(data, context) {
    _userNameController.text = data['user_name'];
    _emailController.text = data['email'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hope you are doing well!',
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
                  child: data['profile'] == null
                      ? Icon(
                          Icons.person_outlined,
                          size: 40,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          child: image == null
                              ? Image.network(
                                  data['profile'],
                                  fit: BoxFit.fill,
                                  frameBuilder: (context, child, frame,
                                      wasSynchronouslyLoaded) {
                                    return child;
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.amber,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                )
                              : Image.file(
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
          (value) {},
          readOnly: true,
        ),
        SizedBox(
          height: 20,
        ),
        customButton(
          'Update Profile',
          () {
            if (_formKey.currentState!.validate()) {
              final userName = _userNameController.text.trim();
              UserProfile().updateData(image, userName, userEmail, context);
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
                  text: 'Forgot Password? ',
                  style: TextStyle(
                      fontSize: 17,
                      color:
                          Get.isDarkMode == true ? Colors.white : Colors.black),
                  children: [
                TextSpan(
                  text: 'Reset',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          Get.isDarkMode == true ? Colors.white : Colors.black),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed(forgotPassword),
                ),
              ])),
        ),
      ],
    );
  }
}
