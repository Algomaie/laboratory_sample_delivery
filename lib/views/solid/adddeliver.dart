import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/models/deliver.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/widgets/custom_button.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:alpha/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class addtranperson extends StatefulWidget {
  @override
  _addtranpersonState createState() => _addtranpersonState();
}

class _addtranpersonState extends State<addtranperson> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _vehicleFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();

  bool _isObscure = true;
  CollectionReference doc = FirebaseFirestore.instance.collection('Delivers');
  @override
  void initState() {
    super.initState();
  }

  String? selectedOption;
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
                            child: Column(
                              children: [
                                CustomTextField(
                                  hintText: 'اسم الموصل'.tr,
                                  controller: _nameController,
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
                                  hintText: 'العنوان'.tr,
                                  controller: _addressController,
                                  inputType: TextInputType.text,
                                  prefixIcon: Icons.location_city,
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
                                  hintText: 'الايميل',
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
                                  hintText: 'كلمة السر'.tr,
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
                                  hintText: 'رقم الجوال'.tr,
                                  controller: _phoneController,
                                  focusNode: _phoneFocus,
                                  inputType: TextInputType.phone,
                                  inputAction: TextInputAction.done,
                                  prefixIcon: Icons.phone_android_outlined,
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
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  isNumber: true,
                                  hintText: 'رقم المركبة',
                                  controller: _vehicleController,
                                  focusNode: _vehicleFocus,
                                  inputType: TextInputType.phone,
                                  inputAction: TextInputAction.done,
                                  prefixIcon: Icons.car_crash_outlined,
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile(
                                        title: Text('مفعل'),
                                        value: 'isActive',
                                        groupValue: selectedOption,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedOption = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile(
                                        title: Text('غير مفعل'),
                                        value: 'NotActive',
                                        groupValue: selectedOption,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedOption = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          !authController.isLoading
                              ? Container(
                                  margin: EdgeInsets.all(10),
                                  child: Row(children: [
                                    Expanded(
                                        child: CustomButton(
                                      fontSize: 17,
                                      buttonText: 'إضافة موصل',
                                      onPressed: () =>
                                          _register(authController),
                                    )),
                                    const SizedBox(
                                      width: 10,
                                    ),
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
    String name = _nameController.text.trim();
    String address = _addressController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String phone = _phoneController.text.trim();
    String vehicenum = _phoneController.text.trim();

    if (name.isEmpty) {
      showCustomSnackBar('ادخل اسم الموصل'.tr);
    } else if (address.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('Delivers').doc();
      DeliverModel del = DeliverModel.withId(
          id: docRef.id,
          dname: name,
          address: address,
          email: email,
          image: "assets/images/avatar.jpg",
          date: DateTime.now().toIso8601String(),
          isActive: selectedOption == "isActive" ? true : false,
          pass: password,
          vehicenum: int.parse(vehicenum),
          phone: int.parse(phone),
          status: "طلب مُوصل",
          type: "موصل");
      _nameController.text = _addressController.text = _emailController.text =
          _passwordController.text =
              _phoneController.text = _vehicleController.text = "";
      selectedOption = "NotActive";

      await docRef.set(del.toMap()).then((value) {
        showCustomSnackBar("تم اضافة موصل بنجاح", isError: false);
      }).catchError((error) {
        //if something error in regiestration
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
          case "account-exists-with-different-credential":
          case "email-already-in-use":
            error = "Email already used. Go to login page.";
            print(error);
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_WRONG_PASSWORD":
          case "wrong-password":
            error = "Wrong email/password combination.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_USER_NOT_FOUND":
          case "user-not-found":
            error = "No user found with this email.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_USER_DISABLED":
          case "user-disabled":
            error = "User disabled.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_TOO_MANY_REQUESTS":
          case "operation-not-allowed":
            error = "Too many requests to log into this account.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
          case "operation-not-allowed":
            error = "Server error, please try again later.";
            showCustomSnackBar(error.toString());
            break;
          case "ERROR_INVALID_EMAIL":
          case "invalid-email":
            error = "Email address is invalid.";
            showCustomSnackBar(error.toString());
            break;
          default:
            error = "Register failed. Please try again.";
            showCustomSnackBar(error.toString());
            break;
        }
      });
    }
  }
}
