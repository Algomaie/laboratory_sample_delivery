import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/helper/auth_service.dart';
import 'package:alpha/helper/error_handler.dart';
import 'package:alpha/widgets/dynamic_logo.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:alpha/widgets/custom_button.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:alpha/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController idOrPassportController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          top: false,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: GetBuilder<AuthController>(builder: (authController) {
                return Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          DynamicLogo(width: 200, height: 200),
                          const SizedBox(height: 25),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Column(children: [
                              CustomTextField(
                                hintText: 'email'.tr,
                                controller: emailController,
                                inputType: TextInputType.emailAddress,
                                prefixIcon: Icons.email,
                                divider: false,
                                showTitle: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      style: BorderStyle.solid,
                                      width: 10),
                                ),
                                activeBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      style: BorderStyle.solid,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 1.7),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                hintText: 'كلمة السر'.tr,
                                controller: idOrPassportController,
                                focusNode: _passwordFocus,
                                inputAction: TextInputAction.done,
                                obscureText: _isObscure ? true : false,
                                inputType: _isObscure
                                    ? TextInputType.visiblePassword
                                    : TextInputType.text,
                                prefixIcon: Icons.lock,
                                isPassword: true,
                                showTitle: true,
                                divider: false,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    print(_isObscure);
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      style: BorderStyle.solid,
                                      width: 10),
                                ),
                                activeBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      style: BorderStyle.solid,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 1.7),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ]),
                          ),
                          SizedBox(height: 10.0),
                          !authController.isLoading
                              ? Container(
                                  margin: EdgeInsets.all(10),
                                  child: Row(children: [
                                    Expanded(
                                        child: CustomButton(
                                            fontSize: 17,
                                            border: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 3),
                                            buttonText: 'sign_in'.tr,
                                            onPressed: () async {
                                              if (emailController.text.trim().isEmpty || idOrPassportController.text.trim().isEmpty) {
                                                showCustomSnackBar('ادخل الايميل وكلمة السر!'.tr);
                                              } else {
                                                authController.login(
                                                  emailController.text.trim(),
                                                  idOrPassportController.text.trim(),
                                                );
                                              }
                                            })),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    // Expanded(
                                    //     child: CustomButton(
                                    //   fontSize: 17,
                                    //   buttonText: 'sign_up'.tr,
                                    //   transparent: true,
                                    //   border: BorderSide(
                                    //       color: Theme.of(context).primaryColor,
                                    //       width: 2),
                                    //   onPressed: () => Get.toNamed(
                                    //       RouteHelper.getRegisterRoute()),
                                    // )),
                                  ]),
                                )
                              : Center(child: CircularProgressIndicator()),
                          SizedBox(height: 30),
                        ]),
                  ),
                );
              }),
            ),
          )),
    );
  }
}
