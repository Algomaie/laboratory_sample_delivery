import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/models/custtomer.dart';
import 'package:alpha/models/user_model.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/widgets/custom_button.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:alpha/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  const UpdateUserInfoScreen({Key? key}) : super(key: key);
  @override
  State<UpdateUserInfoScreen> createState() => _UpdateUserInfoScreenState();
}

class _UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  UserModel? model;
  Preference storage = Preference.shared;
  String? userId;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = storage.getString(AppConstants.USER_NAME)!;
    _lastNameController.text = storage.getString(AppConstants.pass)!;
  }

  @override
  Widget build(BuildContext context) {
    var documentSnapshot = FirebaseFirestore.instance
        .collection("Customers")
        .doc(userId ?? storage.getString(AppConstants.USER_ID))
        .get();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'edit_profile'.tr,
            style: GoogleFonts.cairo(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
          elevation: 0.3,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey[50],
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: GetBuilder<AuthController>(builder: (authController) {
              return !authController.isgetDataLoading
                  ? CircularProgressIndicator()
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        width: context.width > 700 ? 700 : context.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            CustomTextField(
                              hintText: 'first_name'.tr,
                              controller: _firstNameController,
                              inputType: TextInputType.text,
                              prefixIcon: Icons.person,
                              textColor: Colors.black,
                              divider: true,
                            ),
                            CustomTextField(
                              hintText: 'كلمة المرور'.tr,
                              controller: _lastNameController,
                              inputType: TextInputType.text,
                              prefixIcon: Icons.person,
                              textColor: Colors.black,
                              divider: true,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            !authController.isLoading
                                ? Container(
                                    margin: const EdgeInsets.all(10),
                                    child: CustomButton(
                                        buttonText: 'update'.tr,
                                        onPressed: () async {
                                          if (storage.getString(
                                                  AppConstants.type) ==
                                              "عميل") {
                                            await FirebaseFirestore.instance
                                                .collection("Customers")
                                                .doc(storage.getString(
                                                    AppConstants.USER_ID))
                                                .update({
                                              "pass": _lastNameController.text
                                                  .trim(),
                                              "dname": _firstNameController.text
                                                  .trim()
                                            }).then((value) {
                                              showCustomSnackBar(
                                                  "تم تعديل بياناتك بنجاح");
                                            });
                                          } else if (storage.getString(
                                                  AppConstants.type) ==
                                              "موصل") {
                                            await FirebaseFirestore.instance
                                                .collection("Delivers")
                                                .doc(storage.getString(
                                                    AppConstants.USER_ID))
                                                .update({
                                              "pass": _lastNameController.text
                                                  .trim(),
                                              "dname": _firstNameController.text
                                                  .trim()
                                            }).then((value) {
                                              showCustomSnackBar(
                                                  "تم تعديل بياناتك بنجاح");
                                            });
                                          } else {
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(storage.getString(
                                                    AppConstants.USER_ID))
                                                .update({
                                              "pass": _lastNameController.text
                                                  .trim(),
                                              "username": _firstNameController
                                                  .text
                                                  .trim()
                                            }).then((value) {
                                              showCustomSnackBar(
                                                  "تم تعديل بياناتك بنجاح");
                                            });
                                          }
                                        }))
                                : Center(child: CircularProgressIndicator()),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    );
            }),
          ),
        ));
  }

  void _update(AuthController authController) async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();

    if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (_lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else {
      var name = _firstName + ' ' + _lastName;

      authController
          .updateUserInfo(userId, username: name)
          .then((status) async {});
    }
  }
}
