import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/models/deliver_model.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/widgets/custom_button.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:alpha/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/helper/auth_service.dart';
import 'package:alpha/helper/error_handler.dart';
import 'package:alpha/widgets/dynamic_logo.dart';

class AddDeliverScreen extends StatefulWidget {
  @override
  _AddDeliverScreenState createState() => _AddDeliverScreenState();
}

class _AddDeliverScreenState extends State<AddDeliverScreen> {
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
                          DynamicLogo(width: 200, height: 200),
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
    String vehicenum = _vehicleController.text.trim();

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
      try {
        final authService = AuthService();
        final uid = await authService.createAccountForUser(email, password);

        DocumentReference docRef =
            FirebaseFirestore.instance.collection('Delivers').doc(uid);
            
        DeliverModel del = DeliverModel.withId(
            id: docRef.id,
            dname: name,
            address: address,
            email: email,
            image: "assets/images/avatar.jpg",
            date: DateTime.now().toIso8601String(),
            isActive: selectedOption == "isActive" ? true : false,
            vehicenum: vehicenum,
            phone: int.tryParse(phone),
            status: "طلب مُوصل",
            type: "موصل");
            
        _nameController.text = _addressController.text = _emailController.text =
            _passwordController.text =
                _phoneController.text = _vehicleController.text = "";
        selectedOption = "NotActive";

        await docRef.set(del.toMap());
        showCustomSnackBar("تم اضافة موصل بنجاح", isError: false);
      } catch (error) {
        ErrorHandler.handleError(error);
      }
    }
  }
}
