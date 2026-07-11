import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/models/sample.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/widgets/custom_button.dart';
import 'package:alpha/widgets/custom_snackbar.dart';
import 'package:alpha/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/widgets/dynamic_logo.dart';

class addsimple extends StatefulWidget {
  @override
  _addsimpleState createState() => _addsimpleState();
}

class _addsimpleState extends State<addsimple> {
  final FocusNode mf1 = FocusNode();
  final FocusNode mf2 = FocusNode();
  final FocusNode mf3 = FocusNode();
  final TextEditingController m1 = TextEditingController();
  final TextEditingController m2 = TextEditingController();
  final TextEditingController m3 = TextEditingController();
  CollectionReference doc = FirebaseFirestore.instance.collection('Delivers');

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
                                  hintText: 'الرسالة الاولى'.tr,
                                  controller: m1,
                                  inputType: TextInputType.text,
                                  prefixIcon: Icons.message,
                                  maxLines: 2,
                                  focusNode: mf1,
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
                                  maxLines: 2,
                                  hintText: 'الرسالة الثاني',
                                  controller: m2,
                                  focusNode: mf2,
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.done,
                                  prefixIcon: Icons.message_rounded,
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
                                  maxLines: 2,
                                  hintText: 'الرسالة الثالث',
                                  controller: m3,
                                  focusNode: mf3,
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.done,
                                  prefixIcon: Icons.message_rounded,
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
                                      buttonText: 'إضافة الرسائل',
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
    String m11 = m1.text.trim();
    String m22 = m2.text.trim();
    String m33 = m2.text.trim();

    if (m11.isEmpty) {
      showCustomSnackBar('ادخل اسم الرسائل'.tr);
    } else if (m22.isEmpty) {
      showCustomSnackBar('ادخل  الرسائل'.tr);
    } else if (m33.isEmpty) {
      showCustomSnackBar('ادخل  الرسائل'.tr);
    } else {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('borading')
          .doc("vDgghtQgqxJeuAmftreh");
      Sample simple =
          Sample(m1: m1.text, id: docRef.id, m2: m2.text, m3: m3.text);
      m1.text = m2.text = m3.text = "";

      print("-----------  ${simple.toJson()} --------------");
      await docRef.update(simple.toJson()).then((value) {
        print("-----------  ${docRef.id} --------------");
        showCustomSnackBar("تم اضافة الرسائل بنجاح", isError: false);
      }).catchError((error) {
        showCustomSnackBar(error.toString());
      });
    }
  }
}
