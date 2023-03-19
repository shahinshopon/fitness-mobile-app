import 'package:fitness/business_logics/auth.dart';
import 'package:fitness/ui/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../route/routes.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final TextEditingController _emailController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
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
                      'Enter your email address to change your password.',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Divider(),
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
                    SizedBox(
                      height: 20,
                    ),
                    customButton(
                      'Continue',
                      () {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text.trim();
                          Auth().resetPassword(email, context);
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: RichText(
                          text: TextSpan(
                              text: 'Don\'t have any account? ',
                              style: TextStyle(
                                fontSize: 17,
                                color: Get.isDarkMode == true
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              children: [
                            TextSpan(
                              text: 'Create Now',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Get.isDarkMode == true
                                      ? Colors.white
                                      : Colors.black),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.toNamed(registration),
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
