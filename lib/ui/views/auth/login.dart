import 'package:fitness/business_logics/auth.dart';
import 'package:fitness/ui/route/routes.dart';
import 'package:fitness/ui/widgets/custom_button.dart';
import 'package:fitness/ui/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RxBool _passwordVisible = true.obs;

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
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'login to your account and get started.',
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
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(forgotPassword);
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Forgot Password',
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    customButton(
                      'Login',
                      () {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          Auth().login(email, password, context);
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
                              text: 'Don\'t have any account? ',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Get.isDarkMode == true
                                      ? Colors.white
                                      : Colors.black),
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
