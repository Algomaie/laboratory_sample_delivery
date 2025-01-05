import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:alpha/widgets/custom_button.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:alpha/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
  }

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
                            height: 30,
                          ),
                          Image.asset(Resources.logo, width: 200, height: 200),
                          const SizedBox(height: 25),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Column(children: [
                              CustomTextField(
                                hintText: 'first_name'.tr,
                                controller: _firstNameController,
                                inputType: TextInputType.text,
                                prefixIcon: Icons.person,
                                divider: false,
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
                                hintText: 'last_name'.tr,
                                controller: _lastNameController,
                                inputType: TextInputType.text,
                                prefixIcon: Icons.person,
                                divider: false,
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
                                hintText: 'email'.tr,
                                controller: _emailController,
                                inputType: TextInputType.emailAddress,
                                prefixIcon: Icons.email,
                                divider: false,
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
                                hintText: 'password'.tr,
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                inputAction: TextInputAction.done,
                                obscureText: _isObscure ? true : false,
                                inputType: _isObscure
                                    ? TextInputType.visiblePassword
                                    : TextInputType.text,
                                prefixIcon: Icons.lock,
                                isPassword: true,
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
                              CustomTextField(
                                hintText: 'confirm_password'.tr,
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocus,
                                obscureText: _isObscure ? true : false,
                                inputAction: TextInputAction.done,
                                inputType: _isObscure
                                    ? TextInputType.visiblePassword
                                    : TextInputType.text,
                                prefixIcon: Icons.lock,
                                isPassword: true,
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
                                onSubmit: (text) => _register(authController),
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
                                      buttonText: 'sign_up'.tr,
                                      onPressed: () =>
                                          _register(authController),
                                    )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: CustomButton(
                                      fontSize: 17,
                                      border: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 3),
                                      buttonText: 'sign_in'.tr,
                                      transparent: true,
                                      onPressed: () => Get.toNamed(
                                          RouteHelper.getLoginRoute()),
                                    )),
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

  void _register(AuthController authController) async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (_lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else {
      var name = _firstName + ' ' + _lastName;

      authController
          .userRegister(name: name, email: _email, password: _password)
          .then((status) async {});
    }
  }
}
